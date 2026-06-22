extends RigidBody3D

var submerged = false
var og = 0
var b = 0
@onready var camera = $Camera3D

	
func _process(delta: float) -> void:
	if submerged:
		b += delta
		position.y = -0.25 * sin(b) + og


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self:
		linear_damp = 2.5
		gravity_scale = 0.0
		submerged = true
		og = position.y
		b = 0
	pass # Replace with function body.
