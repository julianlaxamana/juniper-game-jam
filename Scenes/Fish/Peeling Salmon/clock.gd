extends Node2D

@onready var hour = $hour
@onready var minute = $minute
@onready var watch = $Watch
@onready var button = $Button
@onready var foreground = $foreground
@onready var dialogue = $Encounter

var lost = false

var win = false
var hand_ratio: float = 5 + sqrt(2) - 1
# real clock is too fast, 60
# this could also easily be written to be controlling the minute hand

var pressed: bool = false
var points: Array[Vector2] = []
var revolutions: float = 0.0

# https://www.desmos.com/calculator/iigrxslpgy
# 60 feels fair to me since people are going to keep the cursor close to the center and won't really think about being precise
var epsilon: float = 60
var intervals: Array[float] = [-2*PI - (epsilon/360 * PI), 
							   -2*PI + (epsilon/360 * PI), 2*PI ]
# left win boundary + left lose boundary, right win boundary, right lose boundary

var previous_mouse_location: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	hour.rotation = randf_range(-PI/2, PI/2)
	minute.rotation = randf_range(-PI/2, PI/2)
	set_process(false)
	pass # Replace with function body.
	
	button.button_up.connect(_on_button_button_up)
	
	$AudioStreamPlayer.finished.connect(_on_song_end)

func _on_song_end() -> void:
	$AudioStreamPlayer.play()

func _on_button_button_up() -> void:
	hour.rotation = randf_range(-PI/2, PI/2)
	minute.rotation = randf_range(-PI/2, PI/2)
	
	foreground.visible = false
	button.visible = false
	lost = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (pressed):
		if (points.get(points.size() - 1) != get_global_mouse_position() - minute.position):
			points.append(get_global_mouse_position() - minute.position)
		
			# only compute on every new point added
			if (points.size() >= 1):
				revolutions += (points[points.size() - 2]).angle_to(points[points.size() - 1])
				
		
		# visual feedback shader code
		if (revolutions < intervals[0]):
			#print(clampf(    (revolutions - intervals[0]) / (PI / 2.0), 0, 1    ))
			watch.material.set_shader_parameter("alpha_value", clampf(    -1 * (revolutions - intervals[0]) / (2 * PI * 3), 0, 1    ))
			watch.material.set_shader_parameter("seed_delta", watch.material.get_shader_parameter("seed_delta") + delta)
			
			
		elif (intervals[2] < revolutions):
			watch.material.set_shader_parameter("alpha_value", clampf( (revolutions - intervals[2]) / (2 * PI * 3), 0, 1    ))
			watch.material.set_shader_parameter("seed_delta", watch.material.get_shader_parameter("seed_delta") + delta)
		
	else:
		if (revolutions < intervals[0]):
			foreground.texture = Global.art_dictionary['background']['peeling_salmon']['ancestor']
			button.visible = true
			foreground.visible = true
			lost = true
			
			
		elif ((intervals[0] < revolutions) and (revolutions < intervals[1])):
			win = true
			get_tree().create_timer(.1).timeout.connect(_on_win_timer_timeout)

		elif (intervals[2] < revolutions):
			foreground.texture = Global.art_dictionary['background']['peeling_salmon']['ashes']
			button.visible = true
			foreground.visible = true
			lost = true
		points = []
		revolutions = 0
		set_process(false)


func _on_win_timer_timeout() -> void:
	dialogue.visible = true
	dialogue.initialize_scene("clock_win")

#contorlling minute hand
func _input(event):
	if (not lost and event.is_action("m1") and (not win)):
		if (not pressed):
			pressed = true
			set_process(true)
			
			# most likely, user clicks somewhere not aligned with hour hand and so
			# let's calculate where the minute hand should be
			var delta_theta = Vector2.from_angle(minute.rotation).angle_to(get_global_mouse_position() - minute.position)
			
			# update hands
			minute.rotation += delta_theta
			hour.rotation += delta_theta * (1.0 / hand_ratio)
			
			previous_mouse_location = get_global_mouse_position() - minute.position
		else:
			watch.material.set_shader_parameter("alpha_value", 0)
			pressed = false
			
	if event is InputEventMouseMotion and pressed:
		minute.rotation = (get_global_mouse_position() - minute.position).angle()
		hour.rotation += (previous_mouse_location.angle_to(get_global_mouse_position() - minute.position)) * (1.0 / hand_ratio)
		previous_mouse_location = get_global_mouse_position() - minute.position
	
	#if event.is_action_pressed("r"):
		#noise.material.set_shader_parameter("alpha_value", 1 )


#dialogue.load_dialogue("res://assets/dialogue/test.json")["ball_win"]
