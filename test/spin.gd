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
		
		# There's a few things i can think of doing circle detection with an arbitrary center is 
		# (beside online suggestions which basically suggest an optical ai model)
		# would be to ensure that the L/R and U/D deviation is vaguely about the same
		# and that no points are really close to this supposed center (this however would force a minimum circle size (but i don't expect that to be a problem))
		# however, i'm just going to ensure that from point to point, there's atleast 1 vector that points in 6 different ranges, similar to the
		# discretized spin detector
		
		
		
		# at the end, calculate circle accuracy
		
		if Input.is_action_just_pressed("q"):
			# make sure nonempty
			if (len(line2d.points) != 0):
				var is_circle = true
				# check if the endpoints are close to eachother, we can save compute if they aren't
				
				var position_delta = (line2d.get_point_position(0) - line2d.get_point_position(line2d.get_point_count() - 1)).abs()
				
				# Manhattan distance 50 both ways seems fine to me
				is_circle = position_delta < Vector2(50, 50)
				
				if (is_circle):
					# is circle? 6 regions like last time, 1 2 3 4 5 6
					var direction_bins = [false, false, false, false, false, false]
					#                     1       2      3       4       5      6
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
					is_circle = direction_bins[0] and direction_bins[1] and direction_bins[2] and direction_bins[3] and direction_bins[4] and direction_bins[5]
				
				# actually computing accuracy
				
				
				

			
		
		#line2d.clear_points()
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	reeled = true
	print($"Node2D".get_child(1))
	area.get_parent().reparent($"Node2D")
	pass # Replace with function body.
