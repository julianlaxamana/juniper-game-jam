extends Control

@onready var area = $"../Area3D"
@onready var fisher = $"../CharacterBody3D"
const BOBBER = preload("res://game/bobber.tscn")
const FISH = preload("res://test/water.tscn")

var catch = false
var scene = null
var fish = null

var look = false
var bruh = true

var currBobber = null
func _ready() -> void:
	$Compendium.toggle()
	$Compendium.toggle()

	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("m1") && currBobber == null && scene == null && bruh:
		bruh = false
		$"../CharacterBody3D".bruh = false
		$Control.visible = false
		$Control2.visible = true
		$Control2/Img4373.visible = false
		var bobber_instance = BOBBER.instantiate()
		$"../Water/Area3D".body_entered.connect(bobber_instance._on_area_3d_body_entered)
		bobber_instance.basis = $"../CharacterBody3D".head.transform.basis
		add_child(bobber_instance)
		bobber_instance.camera.current = true
		bobber_instance.global_position = fisher.global_position
		bobber_instance.apply_force(-300.0 * $"../CharacterBody3D".head.transform.basis.z)
		bobber_instance.apply_force(Vector3(0.0, 250.0, 0.0))
		currBobber = bobber_instance
		$"../AudioStreamPlayer3D4".stream = load("res://Assets/audiopapkin-fishing-reel-302355.wav")
		$"../AudioStreamPlayer3D4".play()
	elif Input.is_action_just_pressed("m2") and $Timer.is_stopped() and currBobber != null:
		bruh = true
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
		$"../AudioStreamPlayer3D4".stream = load("res://Assets/reel-back.wav")
		$"../AudioStreamPlayer3D4".play()
	
	if look:
		$"../CharacterBody3D".head.global_rotation.x = deg_to_rad(10)
		$"../CharacterBody3D".head.global_rotation.z = 0.0
		$"../CharacterBody3D".head.global_rotation.y = lerp($"../CharacterBody3D".global_rotation.y, -2 * PI, 0.5)
		$"../CharacterBody3D".position = Vector3(2.5, 0.9, -10)
		
	if Input.is_action_just_pressed("tab") and bruh:
		$"../CharacterBody3D".bruh =false
		bruh = false
		$Control.visible = $Compendium.on
		$Compendium.visible = true
		$Compendium.toggle()
	elif Input.is_action_just_pressed("tab") and $Compendium.on:
		$"../CharacterBody3D".bruh =true
		bruh = true
		$Control.visible = $Compendium.on
		$Compendium.visible = true
		$Compendium.toggle()
	
	if Input.is_action_just_pressed("e") and bruh:
		$"../CharacterBody3D".bruh =false
		bruh = false
		$Control.visible = $Audio.on
		$Audio.visible = true
		$Audio.toggle()
	elif Input.is_action_just_pressed("e") and $Audio.on:
		$"../CharacterBody3D".bruh =true
		bruh = true
		$Control.visible = $Audio.on
		$Audio.visible = true
		$Audio.toggle()
	
	if currBobber != null && currBobber.visible:
		$"../Path3D".curve.set_point_position(0, $"../CharacterBody3D".rod.global_position)
		$"../Path3D".curve.set_point_position(1, currBobber.global_position)
		$"../Path3D".visible = true
	else:
		$"../Path3D".visible = false
	if Input.is_action_just_pressed("m1") and currBobber != null and currBobber.tickle and fish == null:
		fish = FISH.instantiate()
		$AnimationPlayer.play('dissolbe')
		await $AnimationPlayer.animation_finished
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../Node2D".add_child(fish)
		fish.connect("catch", _on_catch)
		fish.connect("skibidi", skibidi)
		$"../CharacterBody3D".bruh = false
		$Control2/Img4373.visible = true
		bruh = false
		$AnimationPlayer.play_backwards('dissolbe')
		$"../WorldEnvironment".environment = load("res://test/2d.tres")
		for i in range(10):
			get_parent().get_child(i).visible = false
		currBobber.visible = false
		
		
	if catch && currBobber != null:
		currBobber.global_position = lerp(currBobber.global_position, $"../CharacterBody3D".global_position, 0.1)
func minnow_load():
	$Control2.visible = true
	$Control2/Img4373.visible = true
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
	bruh = false
	$AnimationPlayer.play_backwards('dissolbe')
	$"../WorldEnvironment".environment = load("res://test/2d.tres")
	$"../AudioStreamPlayer3D2".stop()
	$"../AudioStreamPlayer3D2".stream = load("res://Assets/Looking for my Fish Wife.wav")
	$"../AudioStreamPlayer3D2".play(0)
	for i in range(10):
		get_parent().get_child(i).visible = false
var ballin = null
func ball():
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var ball = load("res://Scenes/Fish/Soccer/soccer.tscn")
	ballin = ball.instantiate()
	ballin.connect("finished", ball_done)
	$"../Node2D".add_child(ballin)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play_backwards('dissolbe')
	$"../AudioStreamPlayer3D2".stop()
	look = true
func ball_done():
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ballin.queue_free()
	ballin = null
	bruh = true
	$AnimationPlayer.play_backwards('dissolbe')
	$"../CharacterBody3D".bruh = false
	$"../AudioStreamPlayer3D2".play()
	$"../RigidBody3D2/Sprite3D/AnimationPlayer".play("new_animation")
	
func control():
	$Control.visible = true
	$Control2.visible = false
	bruh = true
	$"../CharacterBody3D".bruh = true
	$"../AudioStreamPlayer3D2".stop()
	$"../AudioStreamPlayer3D2".stream = load("res://Assets/FishThemeRev2.wav")
	$"../AudioStreamPlayer3D2".play(0)
func skibidi(fih: Node2D):
	$Control2.visible = false
	bruh = true
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
	print(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)))
	if  ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)) == "uid://ws57b2yl4skw":
		print(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)))
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", minnow_load)
		scene.log = "test"
		bruh = false
		$"../CharacterBody3D".bruh = false
	elif ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)) == "uid://3jt3wv4w5lt4":
		print(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)))
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", control)
		scene.log = "wife"
		bruh = false
		$"../CharacterBody3D".bruh = false
	elif ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)) == "uid://cuoiyu1t3uyxu":
		print(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)))
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", minnow_load)
		scene.log = "not wife"
		bruh = false
		$"../CharacterBody3D".bruh = false
	elif ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)) == "uid://nxfxhceuqsxk":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", peeling)
		scene.log = "peeling"
		bruh = false
		$"../CharacterBody3D".bruh = false
	elif ResourceUID.id_to_text(ResourceLoader.get_resource_uid(fih.sprite.texture.resource_path)) == "uid://cbejyade11ep8":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.connect("minigame", ball)
		scene.log = "ball"
		bruh = false
		$"../CharacterBody3D".bruh = false
		
	$"../WorldEnvironment".environment = load("res://test/new_environment.tres")
func peeling():
	$"../CharacterBody3D".bruh = false
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var ball = load("res://Scenes/Fish/Peeling Salmon/clock.tscn")
	ballin = ball.instantiate()
	ballin.connect("done", peel_done)
	$"../Node2D".add_child(ballin)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play_backwards('dissolbe')
	$"../AudioStreamPlayer3D2".stop()
	
func peel_done():
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var test = preload("res://ui/dialogue.tscn")
	scene = test.instantiate()
	scene.log = "happy_salmon"
	add_child(scene)
	$AnimationPlayer.play_backwards('dissolbe')
	$"../CharacterBody3D".bruh = true
	bruh = true
	$"../AudioStreamPlayer3D2".play()
	
func _on_catch() -> void:
	if currBobber != null:
		currBobber.tickle = false
		currBobber.submerged = false
	catch = true
	$Timer.start()
	$"../AudioStreamPlayer3D4".stream = load("res://Assets/reel-back.wav")
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
		$"../CharacterBody3D".bruh = false
	pass # Replace with function body.


func _on_audio_stream_player_3d_2_finished() -> void:
	$"../AudioStreamPlayer3D2".play(0)
	pass # Replace with function body.


func _on_audio_stream_player_3d_finished() -> void:
	$"../AudioStreamPlayer3D".play(0)
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	look = false
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var test = preload("res://ui/dialogue.tscn")
	scene = test.instantiate()
	scene.connect("spin", weng)
	scene.connect("prison", weng2)
	scene.log = "ending_start"
	add_child(scene)
	$AnimationPlayer.play_backwards('dissolbe')
	$"../RigidBody3D2/Sprite3D".visible = false
	pass # Replace with function body.

func weng():
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var test = preload("res://Scenes/Ending/ending.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	scene = test.instantiate()
	scene.connect("done", a)
	add_child(scene)
	$AnimationPlayer.play_backwards('dissolbe')
	
func weng2():
	$AnimationPlayer.play('dissolbe')
	await $AnimationPlayer.animation_finished
	var test = preload("res://Scenes/Ending/prison.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	scene = test.instantiate()
	scene.connect("done", a)
	add_child(scene)
	$AnimationPlayer.play_backwards('dissolbe')

func a():
	bruh = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$"../CharacterBody3D".bruh = true
