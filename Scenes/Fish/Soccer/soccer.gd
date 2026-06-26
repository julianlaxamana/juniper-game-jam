extends Node2D

@onready var bar = $ColorRect
@onready var leg = $Leg
@onready var goalie = $Path2D/PathFollow2D
@onready var ball = $ball
@onready var foreground = $Foreground
@onready var dialogue = $Encounter
var intervals = [.25 , .75]

# to keep the bar a certain size
const max_size: int = 974
var initial_position = null


var pressed: bool = false
var angular_velocity: float = 0.0
var velocity_minimum: float = 14
var scaler: float = 3/7.0
#var previous_angle: float = 0.0
var previous_coordinate: Vector2 = Vector2.ZERO

var leg_scale = null

var ball_initial_position
var speed = 1674

@export var smoothing_curve : Curve
@export var color_curve : Curve
var squish = .05


var failure = false
var win = false

var tutorial = true

# Called when the node enters the scene tree for the first time.
func _ready():
	leg_scale = leg.scale.y
	initial_position = bar.position
	bar.size.x = 0
	bar.color = Color.from_hsv(0.0, 0.68, 0.83, 1.0)
	
	
	ball_initial_position = ball.position
	
	$AudioStreamPlayer.finished.connect(_on_song_end)

func _on_song_end() -> void:
	$AudioStreamPlayer.play()


var averager = []


var random_direction


#var delta = 1/60.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(delta)
	if (win):
		ball.translate(Vector2(0, -1 * speed) * delta)
		ball.rotate(delta * 50)
		ball.scale = ball.scale - Vector2(.6, .6) * delta
		ball.scale = Vector2(clampf(ball.scale.x, 0, 1), clampf(ball.scale.y, 0, 1))
		leg.scale = (Vector2(leg_scale, leg_scale) - leg.scale) / 1.03 + leg.scale
	if (failure):
		bar.size.x /= 1.03
		leg.scale = (Vector2(leg_scale, leg_scale) - leg.scale) / 1.03 + leg.scale
		ball.rotate(delta * 50)
		ball.translate(random_direction * delta)
		
	if (pressed and (not win) and (not failure)):
		var location = get_global_mouse_position() - (ball.get_child(0).global_position)
		
		#leg.rotation = (get_global_mouse_position() - leg.position).angle() - PI/2
		
		#angular_velocity = (leg.rotation - previous_angle) / delta
		#averager.append((leg.rotation - previous_angle) / delta)
		
		angular_velocity = abs(((previous_coordinate.angle_to(location)) / delta))
		
		#averager.append((previous_coordinate.angle_to(location)) / delta)
		
		## number here is how many frames you want to average over
		#if (averager.size() == 6):
			#
			## calculated average, this specifically is a lambda function
			## .reduce runs a function on every element
			#angular_velocity = averager.reduce(func(accum, number): return accum + number)/averager.size()
			
			
			#if (angular_velocity > velocity_minimum):
				#print("winning ", angular_velocity)
			#else:
				#print("LOSING ", angular_velocity)
			
			#averager = []
			
			
		#if (angular_velocity > velocity_minimum):
			#print("winning ", angular_velocity)
		#else:
			#print("LOSING ", angular_velocity)
		
		bar.size.x += angular_velocity * scaler
		
		# update
		#previous_angle = leg.rotation
		previous_coordinate = location
		
		
	bar.size.x -= velocity_minimum * scaler
	bar.size.x = clampf(bar.size.x, 0, max_size)
	
	# aesthetics
	bar.color = Color.from_hsv((color_curve.sample(bar.size.x / float(max_size)) * 120)/360.0, 0.68, 0.83, 1.0)
	
	var percent = bar.size.x / float(max_size)
	bar.position = initial_position + Vector2(randi_range(-5, 5), randi_range(-5, 5)) * smoothing_curve.sample(percent)
	
	# this is linear right now but can become cubic
	leg.scale.y = leg_scale - (squish * smoothing_curve.sample(percent))
	leg.scale.x = leg_scale + (squish * smoothing_curve.sample(percent))
	

func _input(event) -> void:
	if (event.is_action("m1") and (not failure) and (not win)):
		if (tutorial):
			ball.get_child(0).set_process(false)
			ball.get_child(0).visible = false
		if (not pressed):
			pressed = true
			
			previous_coordinate = get_global_mouse_position() - ball.position
			
		else:
			pressed = false
			
			
			
			if ( (bar.size.x / float(max_size) > .98) and
				((goalie.progress_ratio < intervals[0]) or (intervals[1] < goalie.progress_ratio)) ):
				
				get_tree().create_timer(2.0).timeout.connect(_on_timer_timeout_win)
				win = true
				
			else:
				random_direction = Vector2(0, speed).rotated(randf_range(-PI/2, PI/2))
				failure = true
				get_tree().create_timer(1).timeout.connect(_on_timer_timeout)
				
			
	#if event is InputEventMouseMotion and pressed:
		#leg.rotation = (get_global_mouse_position() - leg.position).angle() - PI/2
		#previous_angle = leg.rotation

func _on_timer_timeout_win() -> void:
	foreground.visible = true
	$Path2D/PathFollow2D.visible = false
	
	# delay for foreground
	get_tree().create_timer(5).timeout.connect(_on_timer_dialogue_timeout)

func _on_timer_dialogue_timeout() -> void:
	dialogue.visible = true
	dialogue.initialize_scene("ball_win")
	

func _on_timer_timeout() -> void:
	failure = false
	ball.position = ball_initial_position
	ball.rotation = 32.0 * PI / 180.0
