extends Control

var a = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NinePatchRect/RichTextLabel.visible_characters = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("click") and $GrassButtonsArrow.visible:
		print("next")
		$GrassButtonsArrow.visible = false
	a += delta
	$GrassButtonsArrow.position.x = 1221.0 + 2.5 * sin(a * 5)
	pass


func _on_timer_timeout() -> void:
	if $NinePatchRect/RichTextLabel.visible_characters < len($NinePatchRect/RichTextLabel.text):
		$NinePatchRect/RichTextLabel.visible_characters += 1
		$GrassButtonsArrow.visible = false
	else:
		$GrassButtonsArrow.visible = true
		
	pass # Replace with function body.
