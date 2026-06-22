extends Control

@onready var area = $"../Area3D"
@onready var fisher = $"../CharacterBody3D"
const BOBBER = preload("res://game/bobber.tscn")

func _ready() -> void:
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("e"):
		var bobber_instance = BOBBER.instantiate()
		$"../Water/Area3D".body_entered.connect(bobber_instance._on_area_3d_body_entered)
		bobber_instance.basis = $"../CharacterBody3D".head.transform.basis
		add_child(bobber_instance)
		bobber_instance.camera.current = true
		bobber_instance.global_position = fisher.global_position
		bobber_instance.apply_force(-300.0 * $"../CharacterBody3D".head.transform.basis.z)
		bobber_instance.apply_force(Vector3(0.0, 250.0, 0.0))
		
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = false
	pass # Replace with function body.
