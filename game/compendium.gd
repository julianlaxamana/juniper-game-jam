extends Control

var sfx_value = 0
var music_value = 0


var on = false
func toggle():
	on = !on
	if on:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		$AnimationPlayer.play("test")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$Control.visible = false
		$AnimationPlayer.play_backwards("test")

func _process(delta: float) -> void:
	pass
	
func _ready():
	$HSlider.value_changed.connect(_on_music_change)
	$HSlider2.value_changed.connect(_on_sfx_change)
	
	music_value = $HSlider.value
	sfx_value = $HSlider2.value
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if on:
		$Control.visible = true
	pass # Replace with function body.


func _on_music_change(delta) -> void:
	
	for n in get_tree().get_nodes_in_group("music_players"):
		n.volume_db += delta
	
func _on_sfx_change(delta) -> void:
	
	for n in get_tree().get_nodes_in_group("sfx_players"):
		n.volume_db += delta
