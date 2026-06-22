extends RigidBody3D

var submerged = false
var og = 0
var b = 0

func _process(delta: float) -> void:
	if submerged:
		b += delta
		position.y = -0.25 * sin(b) + og
	if Input.is_action_just_pressed("e"):
		apply_force(-300.0 * $"../CharacterBody3D".head.transform.basis.z)
		apply_force(Vector3(0.0, 250.0, 0.0))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == self:
		linear_damp = 2.5
		gravity_scale = 0.0
		submerged = true
		og = position.y
		b = 0
	pass # Replace with function body.
