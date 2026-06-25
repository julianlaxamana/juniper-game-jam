extends Control

@onready var area = $"../Area3D"
@onready var fisher = $"../CharacterBody3D"
const BOBBER = preload("res://game/bobber.tscn")
const FISH = preload("res://test/water.tscn")

var catch = false

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
		
	if Input.is_action_just_pressed("q") and currBobber != null and currBobber.tickle:
		$AnimationPlayer.play('dissolbe')
		await $AnimationPlayer.animation_finished
		var fish = FISH.instantiate()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$"../Node2D".add_child(fish)
		fish.connect("catch", _on_catch)
		fish.connect("skibidi", skibidi)
		$AnimationPlayer.play_backwards('dissolbe')
		$"../WorldEnvironment".environment = load("res://test/2d.tres")
		for i in range(8):
			get_parent().get_child(i).visible = false
		currBobber.visible = false
		
		
	if catch:
		currBobber.global_position = lerp(currBobber.global_position, $"../CharacterBody3D".global_position, 0.1)

func skibidi():
	for i in range(8):
		get_parent().get_child(i).visible = true
	currBobber.visible = true
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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	catch = false
	currBobber.queue_free()
	$"../CharacterBody3D".camera.current = true
	pass # Replace with function body.
