extends Node2D


@onready var one = $TopRight
@onready var two = $Top
@onready var three = $TopLeft
@onready var four = $BottomLeft
@onready var five = $Bottom
@onready var six = $BottomRight


# a signifier for if M1 is held down to run circle detection
var is_circling : bool = false 
var is_clockwise : Variant = null

var starting_region : int = 1
var current_region : int = 1
var next_region : int = 1

var current_velocity : float = 0.0
var revolution_count : int = 0

var points : Array = []

var hitbox_dictionary : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	one.mouse_entered.connect(_on_mouse_entered.bind(one))
	two.mouse_entered.connect(_on_mouse_entered.bind(two))
	three.mouse_entered.connect(_on_mouse_entered.bind(three))
	four.mouse_entered.connect(_on_mouse_entered.bind(four))
	five.mouse_entered.connect(_on_mouse_entered.bind(five))
	six.mouse_entered.connect(_on_mouse_entered.bind(six))
	
	hitbox_dictionary[one] = 1
	hitbox_dictionary[two] = 2
	hitbox_dictionary[three] = 3
	hitbox_dictionary[four] = 4
	hitbox_dictionary[five] = 5
	hitbox_dictionary[six] = 6
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_circling):
		if (points.get(points.size() - 1) != get_global_mouse_position()):
			points.append(get_global_mouse_position())
	else:
		points = []
		set_process(false)

# region entered signal function
func _on_mouse_entered(node):
	next_region = hitbox_dictionary[node]

func _input(event):
	# referenced
	# https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html#mouse-motion
	if event.is_action("m1"):
		if not is_circling and event.pressed:
			starting_region = next_region
			current_region = next_region
			is_circling = true
			set_process(true)
		if is_circling and not event.pressed:
			is_circling = false
			is_clockwise = null
			
			if (revolution_count >= 1):
				print("circle score ", compute_circle_accuracy(points))
			
			revolution_count = 0
			
		print("act")

	# circling
	if event is InputEventMouseMotion and is_circling:
		# initial direction detection
		if (is_clockwise == null):
			if (next_region != starting_region):
				# edge cases
				if (current_region == 6 && next_region == 1):
					is_clockwise = true
					starting_region = current_region
				elif (current_region == 6 && next_region == 5):
					is_clockwise = false
					starting_region = current_region
				elif (current_region == 1 && next_region == 6):
					is_clockwise = true
					starting_region = current_region
				elif (current_region == 1 && next_region == 2):
					is_clockwise = false
					starting_region = current_region
				else:
					is_clockwise = (starting_region > next_region)
					starting_region = current_region
		
		# is the next section the right way?
		elif (is_clockwise):
			# edge case
			if (current_region == 1 && next_region == 6):
				current_region = next_region
				
				# made a loop?
				if (current_region == starting_region):
					revolution_count += 1
					
			# default case
			elif (current_region - 1 == next_region):
				
				current_region = next_region
				# made a loop?
				if (current_region == starting_region):
					revolution_count += 1
					
					
			# set speed
			current_velocity = event.velocity.length()
		# other case
		elif (is_clockwise == false):
			
			# edge case
			if (current_region == 6 && next_region == 1):
				current_region = next_region
				
				# made a loop?
				if (current_region == starting_region):
					revolution_count += 1
				
			# general case
			elif (current_region + 1 == next_region):
				current_region = next_region
				
				# made a loop?
				if (current_region == starting_region):
					revolution_count += 1
			
			# set speed
			current_velocity = event.velocity.length()
	if event.is_action("e"):
		print("start ", starting_region)
		print("current ", current_region)
		print("next ", next_region)
		print(is_clockwise)
		print(revolution_count)
		


# helper function that 
# given an array of Vector2 (points)
# outputs a percentage
func compute_circle_accuracy(points: Array) -> float:
	# we don't need to calculate the center this time

	var center = get_viewport_rect().size/2
	
	# radius calculation
	var radius : float = 0.0
	for p in points:
		radius += center.distance_to(p)
	radius /= points.size()
	
	
	# now calculate the average distance
	var error : float = 0.0
	for p in points:
		# imagine a line that goes from the center to a particular point
		# we want to then find the point that lies a radius away on this line
		# and then calculate the distance from these 2 points
		
		# happens to just be equivalent to the distance of
		# (point, center) - radius
		error += absf(p.distance_to(center) - radius)
	error /= points.size()
	
	# on experimentation and comparison with the neal.fun circle
	# firstly we want a function that takes [0, inf) and outputs a percent
	# must have (0, 1) and then ideally purely decreasing
	# e^-x does this
	# https://www.desmos.com/calculator/xtomoftjdy
	# the base influences how fast it decreases
	# d helps spread out this decrease
	print("avg distance error ", error)
	return exp(-1 * error / 80.0)
