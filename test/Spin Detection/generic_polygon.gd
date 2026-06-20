extends Area2D

@onready var hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox = get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hitbox_toggle(state: bool):
	hitbox.disabled = state
	pass
	
func _input(event):
	# referenced
	if event.is_action("m1"):
		# record starting coordinates and start dragging
		if not is_circling and event.pressed:
			is_circling = true
		if is_circling and not event.pressed:
			is_circling = false

	# circling
	if event is InputEventMouseMotion and is_circling:
		# While dragging, move the camera with the mouse
		print(event)
