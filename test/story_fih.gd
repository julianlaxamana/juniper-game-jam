extends RigidBody2D

var health = 0.0
signal caught
@onready var sprite = $MinnowWorkerNormalSticker

var fishes = [
"res://Assets/PEELING_SALMON_STICKER.png", 
"res://Assets/MINNOW_WORKER_NORMAL_STICKER.png", 
"res://Assets/PUFFERBALL_FLAT_STICKER.png"
]

static var story_progression = 0

func _ready() -> void:
	if story_progression >= 3:
		$MinnowWorkerNormalSticker.texture = load(fishes[randi_range(0, 2)])
		return
	if (story_progression % 3 == 0):
		$MinnowWorkerNormalSticker.texture = load(fishes[1])
	elif(story_progression % 3 == 1):
		$MinnowWorkerNormalSticker.texture = load(fishes[0])
	elif(story_progression % 3 == 2):
		$MinnowWorkerNormalSticker.texture = load(fishes[2])


func _process(delta: float) -> void:
	if get_parent().caught:
		return
	if linear_velocity.x < 0:
		$MinnowWorkerNormalSticker.scale.x = lerp($MinnowWorkerNormalSticker.scale.x, 0.2, 0.5)
	elif linear_velocity.x > 0:
		$MinnowWorkerNormalSticker.scale.x = lerp($MinnowWorkerNormalSticker.scale.x, -0.2, 0.5)
	$ProgressBar.value = health / 2.0
	
	if health > 200:
		story_progression += 1
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
