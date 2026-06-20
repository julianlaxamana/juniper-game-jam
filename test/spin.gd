extends Node2D

@onready var line2d = $Line2D

var reeled = false
var circle_accuracy = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# If you're using "a" to serve as how long it takes, A is isn't getting reset as of now
var a = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# get mouse position
	a += delta
	$Line2D2.points = [Vector2(720.0, 0.0), $Node2D.global_position]
	var scalar = ($Node2D.global_position - get_global_mouse_position()).length()
	$Node2D.rotation = scalar / 500.0 * sin(a * scalar / 700.0)
	if not reeled:
		$Node2D.global_position = lerp($Node2D.global_position, get_global_mouse_position(), 0.05)
	else:
		$Node2D.global_position = lerp($Node2D.global_position, Vector2(720.0, -20.0), 0.05)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		
		# only add new point if it's actually new
		if (line2d.get_point_position(line2d.get_point_count() - 1) != get_global_mouse_position()):
			line2d.add_point(get_global_mouse_position())
	else:
		if (is_circle(line2d.points)):
			print("circle score ", compute_circle_accuracy(line2d.points))
		line2d.clear_points()


func _on_area_2d_area_entered(area: Area2D) -> void:
	reeled = true
	print($"Node2D".get_child(1))
	area.get_parent().reparent($"Node2D")
	pass # Replace with function body.


# helper function for reusability
# given an array of Vector2 (points)
# outputs if it's a circle based on vectors and nearby starting/endpoints
func is_circle(points: Array) -> bool:
	# assume it's true
	
	if (points.size() == 0):
		return false
		
	# check if the endpoints are close to eachother, we can save compute if they aren't
	# distance < 90 seems fair to me
	print(points[0].distance_to(points[points.size() - 1]))
	if (points[0].distance_to(points[points.size() - 1]) < 90 == false):
		return false
	
	# There's a few things i can think of doing circle detection with an arbitrary center is 
	# (beside online suggestions which basically suggest an optical ai model)
	# would be to ensure that the L/R and U/D deviation is vaguely about the same
	# and that no points are really close to this supposed center (this however would force a minimum circle size (but i don't expect that to be a problem))
	# however, i'm just going to ensure that from point to point, there's atleast 1 vector that points in 6 different ranges, similar to the
	# discretized spin detector
	
	
	# is circle? 6 regions like last time, 1 2 3 4 5 6
	#                     1       2      3       4       5      6
	var direction_bins = [false, false, false, false, false, false]

	for i in range(line2d.get_point_count()):
		# create vector pointing towards next point and then take it's angle (computes arctan y/x)
		var direction = line2d.get_point_position(i).direction_to(line2d.get_point_position(i+1)).angle()
		
		# we aren't computing the vector direction from the end point to the start but 
		# the bins are really wide so this shouldn't be a problem
		
		# going from left to right in interval starts with region 3
		if ((-PI <= direction) and (direction < -2*PI/3)):
			direction_bins[2] = true
		elif ((-2*PI/3 <= direction) and (direction < -PI/3)):
			direction_bins[1] = true
		elif ((-PI/3 <= direction) and (direction < 0)):
			direction_bins[0] = true
		elif ((0 <= direction) and (direction < PI/3)):
			direction_bins[5] = true
		elif ((PI/3 <= direction) and (direction < 2*PI/3)):
			direction_bins[4] = true
		elif ((2*PI/3 <= direction) and (direction < PI)):
			direction_bins[3] = true

	# final pass
	return (direction_bins[0] and direction_bins[1] and direction_bins[2] and direction_bins[3] and direction_bins[4] and direction_bins[5])

# helper function that 
# given an array of Vector2 (points)
# outputs a percentage
func compute_circle_accuracy(points: Array) -> float:
	var center = Vector2(0.0, 0.0)
	
	# we'll favor the player and calculate the radius and center that will minimize the average distance during computation
	for p in points:
		center.x += p.x
		center.y += p.y
	
	center.y /= points.size()
	center.x /= points.size()
	
	#TODO remove this eventually
	# visual indicator of center for now
	var temp = Sprite2D.new()
	add_child(temp)
	temp.texture = load("res://icon.svg")
	temp.position = center
	#TODO
	
	# now that we know the center we can calculate average radius
	var radius = 0.0
	for p in points:
		radius += center.distance_to(p)
	radius /= points.size()
	
	
	# now calculate the average distance
	var error = 0.0
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
