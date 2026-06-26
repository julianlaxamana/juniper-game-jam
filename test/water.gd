extends Node2D

var fish = null
var caught = false
var transition = false
@onready var fih = preload("res://test/fih.tscn")
@onready var story = preload("res://test/story_fih.tscn")
signal catch
signal skibidi

var MAX_FISH = 4
func _ready() -> void:
	var fish_count = randi_range(1, MAX_FISH)
	var special = randi_range(10,10)
	for i in range(fish_count):
		var new_fish = fih.instantiate()
		new_fish.position = Vector2(randi_range(100, 1180), (randi_range(100, 680)))
		add_child(new_fish)
		new_fish.connect("caught", _on_fih_caught)
		new_fish.add_to_group("fih")
	for i in range(special):
		var new_fish = story.instantiate()
		new_fish.position = Vector2(randi_range(100, 1180), (randi_range(100, 680)))
		add_child(new_fish)
		new_fish.connect("caught", _on_fih_caught)
		new_fish.add_to_group("fih")
	
func _process(delta: float) -> void:
	$BlueIdle.scale = lerp($BlueIdle.scale, Vector2(0.15, 0.15), 0.5)
	if fish != null:
		fish.global_position = lerp(fish.global_position, $Cursor/FishHook.global_position,0.5)
		
		
	if transition == true:
		position = lerp(position, Vector2(0, -1000), 0.05)
	
func _on_fih_caught(fih: Node2D) -> void:
	$Timer2.start()
	$Timer.start()
	var new_texture = load("res://assets/Blue_reel.png")
	skibidi.emit(fih)
	caught = true
	fish = fih
	$BlueIdle.scale = Vector2(0.10, 0.20)
	$BlueIdle.texture = new_texture
	pass # Replace with function body.
	
func _on_fih_escape() -> void:
	$Timer.start()
	transition = true
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if caught:
		catch.emit()
	queue_free()	
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	transition = true
	pass # Replace with function body.
