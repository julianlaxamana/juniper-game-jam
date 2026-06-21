extends Node2D

@onready var line2d = $Line2D
@onready var hitbox = $hitbox

var reeled: bool = false

var current_velocity: float = 0.0
var circle_accuracy: float = 0.0
var revolution_count: int = 0
var delta_theta: float = 0.0
var center: Vector2 = Vector2(0.0, 0.0)

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
			
			current_velocity = Input.get_last_mouse_screen_velocity().length()
	else:
		if (is_circle(line2d.points)):
			print("circle score ", compute_circle_accuracy(line2d.points))
			print("revolution count ", count_revolutions(line2d.points))
			
			#hitbox detection
			hitbox.get_child(0).polygon = line2d.points
			hitbox.get_child(0)
			
			hitbox.area_entered.connect(_on_hitbox_area_entered)
			
			# hitbox exists for 3 frames, long enough for the signal to proc but short enough
			# so new fish don't enter the area
			get_tree().create_timer(3/60.0).timeout.connect(_on_timeout)
			
			var temp = hitbox.get_child(0)
			
		line2d.clear_points()

func _on_timeout():
	hitbox.get_child(0).polygon = []

func _on_hitbox_area_entered(area):
	# the player's hook is most likely always going to be one of the 2 that get set off initially by it
	# also, there's likely multiple fish at once also going to be caught
	
	# for 1, just make sure the node is actually a fish
	# for 2, we could do a "what's closest to the center of the polygon calculation" and choose the thing with the min distance
	# 
	print(area)

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	reeled = true
	print($"Node2D".get_child(1))
	area.get_parent().reparent($"Node2D")
	pass # Replace with function body.


# helper function for reusability
# given an array of Vector2 (points)
# outputs if it's a circle based on vectors and nearby starting/endpoints
func is_circle(points: Array) -> bool:
	# There's a few things i can think of doing circle detection with an arbitrary center is 
	# (beside online suggestions which basically suggest an optical ai model)
	# would be to ensure that the L/R and U/D deviation is vaguely about the same
	# and that no points are really close to this supposed center (this however would force a minimum circle size (but i don't expect that to be a problem))
	# i'll implemenet a few things
	
	# assume it's true
	
	if (points.size() == 0):
		return false
		
	# check if the endpoints are close to eachother, we can save compute if they aren't
	# distance < 90 seems fair to me
	if (points[0].distance_to(points[points.size() - 1]) < 90 == false):
		return false
	
	
	# is circle? 
	# bins should actually be something fairly low because too high would mean that nearly every direction needs to be covered
	# which means it needs to be a nearly perfect circle 
	# but because the game runs well enough, the delta_x and delta_y's are only a few pixels in each direction
	# which means there won't be a lot of possible theta values we get out
	var bins: int = 6
	var direction_intervals: Array[float] = []
	direction_intervals.resize(bins + 1)
	
	var direction_booleans: Array[bool] = []
	direction_booleans.resize(bins)
	direction_booleans.fill(false)
	
	
	for i in range(bins):
		direction_intervals[i] = -PI + (2.0 * PI / float(bins)) * i
	direction_intervals[-1] = PI
	
	for i in range(line2d.get_point_count()):
		# create vector pointing towards next point and then take it's angle (computes arctan y/x)
		var direction = line2d.get_point_position(i).direction_to(line2d.get_point_position(i+1)).angle()
		
		for j in range(direction_intervals.size() - 1):
			if ((direction_intervals[j] < direction) and (direction < direction_intervals[j + 1])):
				direction_booleans[j] = true

	for b in direction_booleans:
		if (b == false):
			return false

	return true

# helper function that 
# given an array of Vector2 (points)
# outputs a percentage
func compute_circle_accuracy(points: Array) -> float:
	center = Vector2(0.0, 0.0)
	
	# we'll favor the player and calculate the radius and center that will minimize the average distance during computation
	for p in points:
		center.x += p.x
		center.y += p.y
	
	center.y /= points.size()
	center.x /= points.size()
	
	#TODO remove this eventually
	# visual indicator of center for now
	var temp = Sprite2D.new()
	#add_child(temp)
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
	return exp(-1 * error / 80.0)

func count_revolutions(points: Array) -> int:
	delta_theta = 0
	# this here calculates the theta difference as a percentage of a whole circle * (circumference while assuming the radius from the point before)
	#                             v1  - center (to get it in terms of the center).angle_to(v2 - center)
	for i in (points.size() - 1):
		delta_theta += (points[i] - center).angle_to(points[i+1] - center)

	revolution_count = roundi(delta_theta / (2*PI))
	return revolution_count
