extends Control


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/dock2.tscn")
	pass # Replace with function body.


func _on_button_2_button_up() -> void:
	$Credits.visible = !$Credits.visible 
	$CreditsBox.visible = !$CreditsBox.visible 
	pass # Replace with function body.


func _on_texture_button_button_up() -> void:
	$Credits.visible = !$Credits.visible 
	$CreditsBox.visible = !$CreditsBox.visible 
	pass # Replace with function body.


func _on_texture_button_2_button_up() -> void:
	get_tree().change_scene_to_file("res://game/dock2.tscn")
	pass # Replace with function body.
