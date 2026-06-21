extends Sprite2D


var pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = (get_global_mouse_position() - get_viewport_rect().size/2).angle()

func _input(event):
	if event.is_action("m1"):
		if (not pressed):
			set_process(true)
			pressed = true
		else:
			pressed = false
			set_process(false)
	
