extends Node2D

@onready var police = $man
@onready var explosion_sound = $man/AnimationPlayer
@onready var explode = $explode
@onready var man = $man

var velocity_minimum: float = 5
var timer_minimum: float = 3
var scaler: float = 1.0/7.0
var angular_velocity: float = 0.0


var win = false
var pressed = false


@export var smoothing_curve : Curve
var squish = .05
var police_scale = null

var timer: float = 0.0
var time_to_get: float = 2

var fish = []

var ccw = true
var sound = false

# Called when the node enters the scene tree for the first time.
func _ready():
	police_scale = police.scale.x
	fish = [
		$PufferballInflatedSticker,
		$WellSalmonSticker,
		$MinnowWorkerWifeSticker,
	]


var averager = []
var count = 0

@onready var foreground = $foreground
func _delete_daniel() -> void:
	man.visible = false
	
func _show_ending() -> void:
	foreground.visible = true
	get_tree().create_timer(3).timeout.connect(_show_button)
	
func _show_button() -> void:
	$TextureButton.visible = true
	

	
func _on_button_press() -> void:
	#TODO hookup signal changer
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (win and (sound == false)):
		explode.play("explosion")
		$AudioStreamPlayer.volume_db = $AudioStreamPlayer.volume_db + Global.sfx_volume
		$AudioStreamPlayer.play()
		sound = true
		
		man.texture = preload("res://Scenes/Ending/Assets/DANIEL_WENG_DIES.png")
		
		get_tree().create_timer(.4).timeout.connect(_delete_daniel)
		get_tree().create_timer(1.4).timeout.connect(_show_ending)
		
		pass
		#ball.translate(Vector2(0, -1 * speed) * delta)
		#ball.rotate(delta * 50)
		#ball.scale = ball.scale - Vector2(.6, .6) * delta
		#ball.scale = Vector2(clampf(ball.scale.x, 0, 1), clampf(ball.scale.y, 0, 1))
		
	if (pressed and (not win)):
		#leg.rotation = (get_global_mouse_position() - leg.position).angle() - PI/2
		
		#angular_velocity = (leg.rotation - previous_angle) / delta
		#averager.append((leg.rotation - previous_angle) / delta)
		
		
		angular_velocity = abs(police.get_angle_to(get_global_mouse_position())/ delta) 
		
		print(ccw)
		if ccw:
			if (police.get_angle_to(get_global_mouse_position()) > .2):
				print("switch 1")
				ccw = false
				for f in fish:
					f.scale *= Vector2(-1, 1)
		else:
			if (police.get_angle_to(get_global_mouse_position()) < -.2):
				print("switch 2")
				ccw = true
				for f in fish:
					f.scale *= Vector2(-1, 1)
		
		for f in fish:
			f.rotation += police.get_angle_to(get_global_mouse_position()) / 10.0
			
				
			
			
				
				
		
		
		#averager.append(abs(police.get_angle_to(get_global_mouse_position())/ delta))
		police.rotation = (get_global_mouse_position()-police.position).angle()
		
		
		#var location = get_global_mouse_position() - (ball.get_child(0).global_position)
		#angular_velocity = abs(((previous_coordinate.angle_to(location)) / delta))
		
		
	
			
			
			#if (angular_velocity > velocity_minimum):
				#print("winning ", angular_velocity)
			#else:
				#print("LOSING ", angular_velocity)
			
			
		if (angular_velocity > 0 or count < 5):
			timer += delta
			if (not (angular_velocity > 0)):
				count += 1
		else:
			timer = 0
			count = 0
		
		if (timer > timer_minimum):
			win = true
		

		
	
	# aesthetics
	
	for f in fish:
		f.material.set_shader_parameter("alpha_value", smoothing_curve.sample(timer / timer_minimum))
	
	# this is linear right not but can become cubic
	police.scale.y = police_scale + (squish * smoothing_curve.sample(timer / timer_minimum))
	police.scale.x = police_scale - (squish * smoothing_curve.sample(timer / timer_minimum))
	
	
	
	

#contorlling minute hand
func _input(event) -> void:
	if (event.is_action("m1") and not win):
		if (not pressed):
			pressed = true
			
		else:
			timer = 0
			count = 0
			pressed = false
			
			
