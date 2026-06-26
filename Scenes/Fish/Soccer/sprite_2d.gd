extends Sprite2D

var flipped = false
var scaler = 1.0
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not flipped:
		rotation += delta
	else:
		rotation -= delta
	
	timer += delta
	if (timer >= 1):
		timer = 0
		flipped = not flipped
		
		scale = Vector2(-1 * scale.x, scale.y)
		rotation = randi_range(-PI/2.0, PI/2.0)
