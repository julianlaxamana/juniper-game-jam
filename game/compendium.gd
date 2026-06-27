extends Control

var sfx_value = 0
var music_value = 0

var items = [
	{"fish_name": "Peeling Salmon", "caught": false, "biggest": "N/A", "sprite": "res://Assets/PEELING_SALMON_STICKER.png"},
	{"fish_name": "Salmon", "caught": false, "biggest": "N/A", "sprite": "res://Assets/WELL_SALMON.png"},
	{"fish_name": "Minnow-mal Wage Worker", "caught": false, "biggest": "N/A", "sprite": "res://Assets/MINNOW_WORKER_NORMAL_STICKER.png"},
	{"fish_name": "Minnow-mal Wage Worker's Wife", "caught": false, "biggest": "N/A", "sprite": "res://Assets/MINNOW_WORKER_WIFE_STICKER.png"},
	{"fish_name": "Pufferball", "caught": false, "biggest": "N/A", "sprite": "res://Assets/PUFFERBALL_FLAT_STICKER.png"},
	{"fish_name": "Goalie Flounder", "caught": false, "biggest": "N/A", "sprite": "res://Scenes/Fish/Soccer/Assets/GOALIE_STICKER.png"},
	{"fish_name": "99 Fihs in The Forest", "caught": false, "biggest": "N/A", "sprite": "res://Assets/99.png"},
	{"fish_name": "brick", "caught": false, "biggest": "N/A", "sprite": "res://Assets/BRICK.png"},
	{"fish_name": "Bobafish", "caught": false, "biggest": "N/A", "sprite": "res://Assets/BOBA.png"},
	{"fish_name": "droy", "caught": false, "biggest": "N/A", "sprite": "res://Assets/DROY.png"},
	{"fish_name": "default_fih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/DEFAULT_FIH.png"},
	{"fish_name": "Manfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/MAN.png"},
	{"fish_name": "Meno", "caught": false, "biggest": "N/A", "sprite": "res://Assets/MENO.png"},
	{"fish_name": "MeowMrFih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/MEOWMRFIH.png"},
	{"fish_name": "The Gooch", "caught": false, "biggest": "N/A", "sprite": "res://Assets/The_Gooch_STICKER.png"},
	{"fish_name": "Galaxy fih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/GALAXY.png"},
	{"fish_name": "Goldfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/GOLDFIH.png"},
	{"fish_name": "Mola Mola", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/MOLA_MOLA.png"},
	{"fish_name": "Grouper and Wrass", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/GROUPER_AND_WRASS.png"},
	{"fish_name": "Pikfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/PIKMIN.png"},
	{"fish_name": "Freakfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/FREAKY.png"},
	{"fish_name": "green", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/GREEN.png"},
	{"fish_name": "spinfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/PROPELLER.png"},
	{"fish_name": "Hatsune Fihku", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/MIKU.png"},
	{"fish_name": ".", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/TINY.png"},
	{"fish_name": "Freddy Fazfih", "caught": false, "biggest": "N/A", "sprite": "res://Assets/Fodder/FREDDY_FAZFIH.png"},
	{"fish_name": "Daniel Weng", "caught": false, "biggest": "N/A", "sprite": "res://Scenes/Ending/Assets/DANIEL_WENG_SPIN.png"}
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
#"res://assets/PUFFERBALL_FLAT_STICKER.png"

var on = false
func toggle():
	on = !on
	if on:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$AnimationPlayer.play("test")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$AnimationPlayer.play_backwards("test")

func update_items():
	for item in items:
		if item["caught"]:
			$ItemList.set_item_text(items.find(item), item["fish_name"])
func _process(delta: float) -> void:
	var a = 0
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
