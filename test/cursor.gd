extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(delta: float) -> void:	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$enclose.add_point(get_global_mouse_position())
		$enclose2.add_point(get_global_mouse_position())
	else:
		$enclose.points = []
		$enclose2.points = []
	if line_intersects_itself($enclose.points):
		var convex = Geometry2D.convex_hull($enclose.points)
		$Area2D/CollisionPolygon2D.polygon = convex
		$enclose.points = []
		$enclose2.points = []

	$Line2D.points = [$Line2D.points[0], $FishHook/Node2D.global_position]
	$FishHook.global_position = get_global_mouse_position()

func line_intersects_itself(points: PackedVector2Array) -> bool:
	for i in range(points.size() - 1):
		var a1 = points[i]
		var a2 = points[i + 1]
		for j in range(i + 2, points.size() - 1):
			if i == 0 and j == points.size() - 2:
				continue
			var b1 = points[j]
			var b2 = points[j + 1]
			
			if segments_intersect(a1, a2, b1, b2):
				return true
	
	return false

func segments_intersect(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2) -> bool:
	var d1 = a2 - a1
	var d2 = b2 - b1
	var cross = d1.cross(d2)
	
	if abs(cross) < 0.0001:
		return false
	
	var t = (b1 - a1).cross(d2) / cross
	var u = (b1 - a1).cross(d1) / cross
	
	return t >= 0 and t <= 1 and u >= 0 and u <= 1
	




func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("fih"):
		body.damage(10)
	pass # Replace with function body.
