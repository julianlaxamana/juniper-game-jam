extends Control

var a = 0
var index = 0
var names
var dialogue
signal minigame
signal spin
signal prison


var log = "ball"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_scene(log)
	
func initialize_scene(scene: String) -> void:
	dialogue = load_dialogue("res://assets/dialogue/test.json")[scene]
	names = dialogue["position"]
	$leftSprite.texture = load(dialogue[dialogue["position"][0]])
	$rightSprite.texture = load(dialogue[dialogue["position"][1]])
	$NinePatchRect/RichTextLabel.text = dialogue["dialogue"][index]["text"]
	$NinePatchRect2/RichTextLabel.text = dialogue["dialogue"][index]["speaker"]
	$NinePatchRect/RichTextLabel.visible_characters = 0

	$AudioStreamPlayer2D.pitch_scale = dialogue["dialogue"][index]["pitch"]
	$AudioStreamPlayer2D.play(randf_range(0, 5))
	pass # Replace with function body.
	
func load_dialogue(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_text = file.get_as_text()
		var json = JSON.new()
		if json.parse(json_text) == OK:
			return json.data
	return {}
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("m1") and $GrassButtonsArrow.visible && index < len(dialogue["dialogue"]) - 1:
		index += 1
		$AudioStreamPlayer2D.play(randf_range(0, 5))
		$NinePatchRect/RichTextLabel.visible_characters = 0
		$NinePatchRect/RichTextLabel.text = dialogue["dialogue"][index]["text"]
		$NinePatchRect2/RichTextLabel.text = dialogue["dialogue"][index]["speaker"]
		$AudioStreamPlayer2D.pitch_scale = dialogue["dialogue"][index]["pitch"]
		$GrassButtonsArrow.visible = false
	elif Input.is_action_just_released("m1") and $GrassButtonsArrow.visible and log != "ending_start":
		minigame.emit()
		queue_free()
	elif Input.is_action_just_released("m1") and $GrassButtonsArrow.visible and log == "ending_start":
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
		$Control. visible = true
	elif  Input.is_action_just_released("m1"):
		$AudioStreamPlayer2D.stop()
		$NinePatchRect/RichTextLabel.visible_characters = 1000
		$AudioStreamPlayer2D.pitch_scale = dialogue["dialogue"][index]["pitch"]
		
	a += delta
	$GrassButtonsArrow.position.x = 1197.19 + 2.5 * sin(a * 5)
	pass


func _on_timer_timeout() -> void:
	if $NinePatchRect/RichTextLabel.visible_characters < len($NinePatchRect/RichTextLabel.text):
		if names.find(dialogue["dialogue"][index]["speaker"]) == 1:
			$rightSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$rightSprite.scale = lerp($rightSprite.scale, Vector2(randf_range(0.35, 0.44), randf_range(0.35, 0.44)), 0.25)
			$leftSprite.modulate = Color(0.5, 0.5, 0.5, 1.0)
			$leftSprite.scale = lerp($leftSprite.scale, Vector2(0.17, 0.17), 0.25)
		else:
			$leftSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$rightSprite.scale = lerp($rightSprite.scale, Vector2(0.34, 0.34), 0.25)
			$rightSprite.modulate = Color(0.5, 0.5, 0.5, 1.0)
			$leftSprite.scale = lerp($leftSprite.scale, Vector2(randf_range(0.20, 0.25), randf_range(0.20, 0.25)), 0.25)
		$NinePatchRect/RichTextLabel.visible_characters += 1
		$GrassButtonsArrow.visible = false
	else:
		$AudioStreamPlayer2D.stop()
		$GrassButtonsArrow.visible = true
		
	pass # Replace with function body.


func _on_button_button_up() -> void:
	spin.emit()
	queue_free()
	pass # Replace with function body.


func _on_button_2_button_up() -> void:
	prison.emit()
	queue_free()
	pass # Replace with function body.
