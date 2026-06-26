extends Control

var items = [
	{"fish_name": "Peeling Salmon", "caught": false, "biggest": "N/A", "sprite": "res://assets/PEELING_SALMON_STICKER.png"},
	{"fish_name": "Minnow-mal Wage Worker", "caught": false, "biggest": "N/A", "sprite": "res://assets/MINNOW_WORKER_NORMAL_STICKER.png"},
	{"fish_name": "Minnow-mal Wage Worker's Wife", "caught": true, "biggest": "N/A", "sprite": "res://assets/MINNOW_WORKER_WIFE_STICKER.png"},
	{"fish_name": "Pufferball", "caught": true, "biggest": "N/A", "sprite": "res://assets/PUFFERBALL_FLAT_STICKER.png"},
	{"fish_name": "Goalie Flounder", "caught": false, "biggest": "N/A", "sprite": "res://assets/PUFFERBALL_FLAT_STICKER.png"},
	{"fish_name": "Goalie Flounder", "caught": false, "biggest": "N/A", "sprite": "res://assets/PUFFERBALL_FLAT_STICKER.png"}
]
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
func update_items():
	for item in items:
		if !item["caught"]:
			$ItemList.add_item("???")
		else:
			$ItemList.add_item(item["fish_name"])
func _process(delta: float) -> void:
	var a = 0
	$Control.global_position = get_global_mouse_position()
	for item in items:
		if item["caught"]:
			a += 1
			
	$ProgressBar.value = a / (len(items) * 1.0) * 100.0
func _ready():
	$Label.visible = false
	$Label3.visible = false
	$PeelingSalmonSticker.visible = false
	update_items()
	
func _on_item_list_item_selected(index: int) -> void:
	$Label.visible = true
	$Label3.visible = true
	$PeelingSalmonSticker.visible = true
	$PeelingSalmonSticker.texture = load(items[index]["sprite"])
	$Label.text = "BIGGEST FIH: " + items[index]["biggest"]
	if !items[index]["caught"]:
		$Label3.text = "???"
		$PeelingSalmonSticker.modulate = Color(0.0, 0.0, 0.0, 1.0)
	else:
		$PeelingSalmonSticker.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$Label3.text = items[index]["fish_name"]
	
		
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if on:
		$Control.visible = true
	pass # Replace with function body.
