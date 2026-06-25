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
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("e") && currBobber == null:
		var bobber_instance = BOBBER.instantiate()
		$"../Water/Area3D".body_entered.connect(bobber_instance._on_area_3d_body_entered)
		bobber_instance.basis = $"../CharacterBody3D".head.transform.basis
		add_child(bobber_instance)
		bobber_instance.camera.current = true
		bobber_instance.global_position = fisher.global_position
		bobber_instance.apply_force(-300.0 * $"../CharacterBody3D".head.transform.basis.z)
		bobber_instance.apply_force(Vector3(0.0, 250.0, 0.0))
		currBobber = bobber_instance
	elif Input.is_action_just_pressed("e"):
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
	
	if currBobber != null && currBobber.visible:
		$"../Path3D".curve.set_point_position(0, $"../CharacterBody3D".rod.global_position)
		$"../Path3D".curve.set_point_position(1, currBobber.global_position)
		$"../Path3D".visible = true
	else:
		$"../Path3D".visible = false
	if Input.is_action_just_pressed("q") and currBobber != null and currBobber.tickle and fish == null:
		$AnimationPlayer.play('dissolbe')
		await $AnimationPlayer.animation_finished
		fish = FISH.instantiate()
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
		
		
	if catch:
		currBobber.global_position = lerp(currBobber.global_position, $"../CharacterBody3D".global_position, 0.1)

func skibidi(fih: Node2D):
	for i in range(10):
		get_parent().get_child(i).visible = true
	currBobber.visible = true
	currBobber.fih.texture = fih.sprite.texture
	if fih.sprite.texture.resource_path == "res://assets/MINNOW_WORKER_NORMAL_STICKER.png":
		var test = preload("res://ui/dialogue.tscn")
		scene = test.instantiate()
		scene.log = "test"
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
	currBobber.tickle = false
	currBobber.submerged = false
	catch = true
	$Timer.start()
	
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
	currBobber.queue_free()
	$"../CharacterBody3D".camera.current = true
	$"../CharacterBody3D".bruh = true
	if scene != null:
		add_child(scene)
	pass # Replace with function body.
