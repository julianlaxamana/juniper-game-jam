extends Node2D
signal done

func _ready():
	$FreesoundCommunityJaildoorclose6173.play()


func _on_freesound_community_jaildoorclose_6173_finished() -> void:
	$TextureButton.visible = true
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	$JailTextCg/AnimationPlayer.play("new_animation")
	pass # Replace with function body.


func _on_texture_button_button_up() -> void:
	done.emit()
	queue_free()
	pass # Replace with function body.
