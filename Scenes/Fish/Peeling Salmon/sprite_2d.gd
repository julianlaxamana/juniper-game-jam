extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var texture = NoiseTexture2D.new()
	texture.noise = FastNoiseLite.new()
	await texture.changed
	var image = texture.get_image()
	var data = image.get_data()
	self.texture = texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
