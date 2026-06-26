extends Control

@onready var area = $"../Area3D"
@onready var fisher = $"../CharacterBody3D"
const BOBBER = preload("res://game/bobber.tscn")
const FISH = preload("res://test/water.tscn")

var catch = false
var scene = null
var fish = null


var currBobber = null
func _ready() -> void:
	$Compendium.toggle()
	$Compendium.toggle()

	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("e") && currBobber == null:
		$Control.visible = false
		$Control2.visible = true
		var bobber_instance = BOBBER.instantiate()
		$"../Water/Area3D".body_entered.connect(bobber_instance._on_area_3d_body_entered)
		bobber_instance.basis = $"../CharacterBody3D".head.transform.basis
		add_child(bobber_instance)
		bobber_instance.camera.current = true
		bobber_instance.global_position = fisher.global_position
		bobber_instance.apply_force(-300.0 * $"../CharacterBody3D".head.transform.basis.z)
		bobber_instance.apply_force(Vector3(0.0, 250.0, 0.0))
		currBobber = bobber_instance
		$"../AudioStreamPlayer3D4".stream = load("res://assets/audiopapkin-fishing-reel-302355.wav")
		$"../AudioStreamPlayer3D4".play()
	elif Input.is_action_just_pressed("e") and $Timer.is_stopped():
		$Control.visible = true
		$Control2.visible = false
		$Timer.start()
		if fish != null:
			fish._on_fih_escape()
		currBobber.tickle = false
		currBobber.submerged = false
		catch = true
		for i in range(10):
			get_parent().get_child(i).visible = true
		currBobber.visible = true
		$"../WorldEnvironment".environment = load("res://test/new_environment.tres")
		$"../AudioStreamPlayer3D4".stream = load("res://assets/reel-back.wav")
		$"../AudioStreamPlayer3D4".play()
		
	if Input.is_action_just_pressed("r"):
		$"../CharacterBody3D".bruh = !$"../CharacterBody3D".bruh
		$Control.visible = $Compendium.on
		$Compendium.visible = true
		$Compendium.toggle()
	
	if currBobber != null && currBobber.visible:
		$"../Path3D".curve.set_point_position(0, $"../CharacterBody3D".rod.global_position)
		$"../Path3D".curve.set_point_position(1, currBobber.global_position)
		$"../Path3D".visible = true
	else:
		$"../Path3D".visible = false
	if Input.is_action_just_pressed("q") and currBobber != null and currBobber.tickle and fish == null:
		fish = FISH.instantiate()
		$AnimationPlayer.play('dissolbe')
		await $AnimationPlayer.animation_finished
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../Node2D".add_child(fish)
		fish.connect("catch", _on_catch)
		fish.connect("skibidi", skibidi)
		$"../CharacterBody3D".bruh = false
		$AnimationPlayer.play_backwards('dissolbe')
		$"../WorldEnvironment".environment = load("res://test/2d.tres")
		for i in range(10):
			get_parent().get_child(i).visible = false
		currBobber.visible = false
		
		
	if catch && currBobber != null:
		currBobber.global_position = lerp(currBobber.global_position, $"../CharacterBody3D".global_position, 0.1)
func minnow_load():
	$Control2.visible = true
	$Control.visible = false
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var minnow = load("res://test/wife_water.tscn")
	fish = minnow.instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"../Node2D".add_child(fish)
	fish.connect("catch", _on_catch)
	fish.connect("skibidi", skibidi)
	$"../CharacterBody3D".bruh = false
	$AnimationPlayer.play_backwards('dissolbe')
	$"../WorldEnvironment".environment = load("res://test/2d.tres")
	$"../AudioStreamPlayer3D2".stop()
	$"../AudioStreamPlayer3D2".stream = load("res://assets/Looking for my Fish Wife.wav")
	$"../AudioStreamPlayer3D2".play(0)
	for i in range(10):
		get_parent().get_child(i).visible = false
	
func control():
	$Control.visible = true
	$Control2.visible = false
	$"../AudioStreamPlayer3D2".stop()
	$"../AudioStreamPlayer3D2".stream = load("res://assets/FishThemeRev2.wav")
	$"../AudioStreamPlayer3D2".play(0)
func skibidi(fih: Node2D):
	$Control2.visible = false
	for item in $Compendium.items:
		if fih.sprite.texture.resource_path == item["sprite"] && !item["caught"]:
			item["caught"] = true
			$"../AudioStreamPlayer3D3".play()
			$Label.visible = true
			$Label/AnimationPlayer.play("yipee")
			
			
	$Compendium.update_items()
	for i in range(10):
		get_parent().get_child(i).visible = true
	if currBobber != null:
		currBobber.visible = true
		currBobber.fih.texture = fih.sprite.texture
	if fih.sprite.texture.resource_path == "res://assets/MINNOW_WORKER_NORMAL_STICKER.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", minnow_load)
		scene.log = "test"
	elif fih.sprite.texture.resource_path == "res://assets/MINNOW_WORKER_WIFE_STICKER.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", control)
		scene.log = "wife"
	elif fih.sprite.texture.resource_path == "res://assets/MINNOW_WORKER_NORMAL_STICKER_.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", control)
		scene.log = "not wife"
	elif fih.sprite.texture.resource_path == "res://assets/PEELING_SALMON_STICKER.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.log = "peeling"
	elif fih.sprite.texture.resource_path == "res://assets/PUFFERBALL_FLAT_STICKER.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.log = "ball"
		
	$"../WorldEnvironment".environment = load("res://test/new_environment.tres")
	
func _on_catch() -> void:
	if currBobber != null:
		currBobber.tickle = false
		currBobber.submerged = false
	catch = true
	$Timer.start()
	$"../AudioStreamPlayer3D4".stream = load("res://assets/reel-back.wav")
	$"../AudioStreamPlayer3D4".play()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = false
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		$RichTextLabel.visible = false
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	fish = null
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	catch = false
	if currBobber != null:
		currBobber.queue_free()
	$"../CharacterBody3D".camera.current = true
	$"../CharacterBody3D".bruh = true
	if scene != null:
		add_child(scene)
	pass # Replace with function body.


func _on_audio_stream_player_3d_2_finished() -> void:
	$"../AudioStreamPlayer3D2".play(0)
	pass # Replace with function body.


func _on_audio_stream_player_3d_finished() -> void:
	$"../AudioStreamPlayer3D".play(0)
	pass # Replace with function body.
