extends RigidBody2D

var health = 0.0
signal caught
@onready var sprite = $MinnowWorkerNormalSticker

var fishes = [
"res://Assets/99.png", 
"res://Assets/BRICK.png", 
"res://Assets/BOBA.png", 
"res://Assets/DROY.png", 
"res://Assets/DEFAULT_FIH.png", 
"res://Assets/Fodder/FREAKY.png",
"res://Assets/Fodder/FREDDY_FAZFIH.png",
"res://Assets/Fodder/FRONT_FACING_FIH.png",
"res://Assets/Fodder/GALAXY.png",
"res://Assets/Fodder/GOLDFIH.png",
"res://Assets/Fodder/GREEN.png",
"res://Assets/Fodder/GROUPER_AND_WRASS.png",
"res://Assets/MAN.png", 
"res://Assets/MENO.png", 
"res://Assets/MEOWMRFIH.png", 
"res://Assets/Fodder/MIKU.png",
"res://Assets/Fodder/MOGUSFIH.png",
"res://Assets/Fodder/MOLA_MOLA.png",
"res://Assets/Fodder/PIKMIN.png",
"res://Assets/Fodder/PROPELLER.png",
"res://Assets/The_Gooch_STICKER.png", 
"res://Assets/Fodder/TINY.png"

]

func _ready() -> void:
	var file = fishes[randi() % len(fishes)]
	$MinnowWorkerNormalSticker.texture = load(file)
	
	
	if (file == "res://Assets/Fodder/TINY.png"):
		$MinnowWorkerNormalSticker.scale = Vector2(1, 1)
		# legit will not be visible if it's not

func _process(delta: float) -> void:
	if get_parent().caught:
		return
	if linear_velocity.x < 0:
		$MinnowWorkerNormalSticker.scale.x = lerp($MinnowWorkerNormalSticker.scale.x, 0.2, 0.5)
	elif linear_velocity.x > 0:
		$MinnowWorkerNormalSticker.scale.x = lerp($MinnowWorkerNormalSticker.scale.x, -0.2, 0.5)
	$ProgressBar.value = health / 2.0
	
	if health > 200:
		caught.emit(self)
		health = 0.0
	pass



func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(1.0, 2.5)
	if randi() % 2 == 1:
		linear_velocity = Vector2.from_angle(randf_range(-2 * PI, 2 * PI)) * randf_range(100.0, 200.0)
	pass # Replace with function body.

func damage(dmg: float) -> void:
	print(health)
	health += dmg
