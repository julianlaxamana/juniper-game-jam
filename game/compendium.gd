extends Control

var items = [
	{"fish_name": "Peeling Salmon", "caught": false, "biggest": "N/A", "sprite": "res://assets/PEELING_SALMON_STICKER.png"},
	{"fish_name": "Minnow-mal Wage Worker", "caught": false, "biggest": "N/A", "sprite": "res://assets/MINNOW_WORKER_NORMAL_STICKER.png"},
	{"fish_name": "Minnow-mal Wage Worker's Wife", "caught": false, "biggest": "N/A", "sprite": "res://assets/MINNOW_WORKER_WIFE_STICKER.png"},
	{"fish_name": "Pufferball", "caught": false, "biggest": "N/A", "sprite": "res://assets/PUFFERBALL_FLAT_STICKER.png"},
	{"fish_name": "Goalie Flounder", "caught": false, "biggest": "N/A", "sprite": "res://Scenes/Fish/Soccer/Assets/GOALIE_STICKER.png"},
	{"fish_name": "99 Fihs in The Forest", "caught": false, "biggest": "N/A", "sprite": "res://assets/99.png"},
	{"fish_name": "brick", "caught": false, "biggest": "N/A", "sprite": "res://assets/BRICK.png"},
	{"fish_name": "Bobafish", "caught": false, "biggest": "N/A", "sprite": "res://assets/BOBA.png"},
	{"fish_name": "droy", "caught": false, "biggest": "N/A", "sprite": "res://assets/DROY.png"},
	{"fish_name": "default_fih", "caught": false, "biggest": "N/A", "sprite": "res://assets/DEFAULT_FIH.png"},
	{"fish_name": "Manfih", "caught": false, "biggest": "N/A", "sprite": "res://assets/MAN.png"},
	{"fish_name": "Meno", "caught": false, "biggest": "N/A", "sprite": "res://assets/MENO.png"},
	{"fish_name": "MeowMrFih", "caught": false, "biggest": "N/A", "sprite": "res://assets/MEOWMRFIH.png"},
	{"fish_name": "The Gooch", "caught": false, "biggest": "N/A", "sprite": "res://assets/The_Gooch_STICKER.png"}
]

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
"res://assets/PUFFERBALL_FLAT_STICKER.png"
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
	$Label.visible = false
	$Label3.visible = false
	$PeelingSalmonSticker.visible = false
	
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
