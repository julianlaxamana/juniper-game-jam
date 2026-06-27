extends Control

var sfx_value = 0
var music_value = 0


<<<<<<< HEAD
#"res://assets/99.png", 
#"res://assets/BRICK.png", 
#"res://assets/BOBA.png", 
#"res://assets/DROY.png", 
#"res://assets/DEFAULT_FIH.png", 
#"res://assets/MAN.png", 
#"res://assets/MENO.png", 
#"res://assets/MEOWMRFIH.png", 
#"res://assets/The_Gooch_STICKER.png", 
#"res://assets/PEELING_SALMON_STICKER.png", 
#"res://assets/MINNOW_WORKER_NORMAL_STICKER.png", 
#"res://assets/PUFFERBALL_FLAT_STICKER.png"
=======
>>>>>>> 4c2aab26bbe921a7758e8342fe5768a33698fdae
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
<<<<<<< HEAD
func update_items():
	for item in items:
		if item["caught"]:
			$ItemList.set_item_text(items.find(item), item["fish_name"])
func _process(delta: float) -> void:
	var a = 0
	$Control.global_position = get_global_mouse_position()
	for item in items:
		if item["caught"]:
			a += 1
			
	$ProgressBar.value = a / (len(items) * 1.0) * 100.0
func _ready():
	for item in items:
		if !item["caught"]:
			$ItemList.add_item("???")
	$Label3.visible = false
	$PeelingSalmonSticker.visible = false
	
func _on_item_list_item_selected(index: int) -> void:
	$Label3.visible = true
	$PeelingSalmonSticker.visible = true
	$PeelingSalmonSticker.texture = load(items[index]["sprite"])
	if !items[index]["caught"]:
		$Label3.text = "???"
		$PeelingSalmonSticker.modulate = Color(0.0, 0.0, 0.0, 1.0)
	else:
		$PeelingSalmonSticker.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$Label3.text = items[index]["fish_name"]
	
		
	pass # Replace with function body.
=======
>>>>>>> 4c2aab26bbe921a7758e8342fe5768a33698fdae

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
