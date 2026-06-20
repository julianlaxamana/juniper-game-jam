extends Node2D

var points = []
var reeled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var a = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# get mouse position
	a += delta
	$Line2D2.points = [Vector2(720.0, 0.0), $Node2D.global_position]
	var scalar = ($Node2D.global_position - get_global_mouse_position()).length()
	$Node2D.rotation = scalar / 500.0 * sin(a * scalar / 700.0)
	if not reeled:
		$Node2D.global_position = lerp($Node2D.global_position, get_global_mouse_position(), 0.05)
	else:
		$Node2D.global_position = lerp($Node2D.global_position, Vector2(720.0, -20.0), 0.05)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		points.push_back(get_global_mouse_position())
		$Line2D.points = points
	else:
		points = []
		$Line2D.points = points
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	reeled = true
	print($"Node2D".get_child(1))
	area.get_parent().reparent($"Node2D")
	pass # Replace with function body.
