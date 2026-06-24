extends Node2D

var fish = null
var caught = false
var transition = false
func _ready() -> void:
	$fih.connect("caught", _on_fih_caught)
	$fih2.connect("caught", _on_fih_caught)
	
func _process(delta: float) -> void:
	$BlueIdle.scale = lerp($BlueIdle.scale, Vector2(0.15, 0.15), 0.5)
	if fish != null:
		fish.global_position = lerp(fish.global_position, $Cursor/FishHook.global_position,0.5)
		
		
	if transition == true:
		position = lerp(position, Vector2(0, -1000), 0.05)
	
func _on_fih_caught(fih: Node2D) -> void:
	$Timer.start()
	$Timer2.start()
	var new_texture = load("res://assets/Blue_reel.png")
	caught = true
	fish = fih
	$BlueIdle.scale = Vector2(0.10, 0.20)
	$BlueIdle.texture = new_texture
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	queue_free()	
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	print("hi")
	transition = true
	pass # Replace with function body.
