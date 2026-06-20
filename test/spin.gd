extends Node2D

var points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# get mouse position
	$Icon.global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		points.push_back(get_global_mouse_position())
		$Line2D.points = points
	else:
		points = []
		$Line2D.points = points
	pass
