extends Control

@onready var area = $"../Area3D"

func _ready() -> void:
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = false
	pass # Replace with function body.
