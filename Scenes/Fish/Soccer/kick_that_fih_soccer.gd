extends Sprite2D

func _ready():
	$AnimationPlayer.play("breh")
func _process(delta: float) -> void:
	position = Vector2(640.0 + randi_range(0, 1), 212.0 + randi_range(0, 1))
