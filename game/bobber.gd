extends RigidBody3D

var submerged = false
var tickle = false
var og = 0
var b = 0

@onready var camera = $Camera3D
@onready var catchTimer = $Timer
@onready var fih = $Sprite3D2
func _ready() -> void:
	catchTimer.wait_time = randf_range(5.0, 10.0)
	#catchTimer.wait_time = 1
	
func _process(delta: float) -> void:
	if submerged:
		b += delta
		position.y = -0.25 * sin(b) + og
	if tickle:
		camera.reparent(get_parent(), true)
		b += delta
		rotation.z = 0.15 * sin(7.5 * b)
	else:
		camera.reparent(self, true)
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self && not submerged:
		catchTimer.start()
		linear_damp = 2.5
		gravity_scale = 0.0
		submerged = true
		og = position.y
		b = 0
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	tickle = true
	pass # Replace with function body.
