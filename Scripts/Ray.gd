class_name Ray extends Node2D

# Info
#	- Direction
#	- Slope

# Comparison
#	- Contains
#	- Intersects (Lines, Segments, Rays)
#	- Bisects (Segments)
#	- Is Opposite Of
#	- Is Same As
#	- Parallel & Perpendicular To
#	- Is Transversal Of

# Fixes
#	- ANGLE BISECTION


var pointA: Point
var pointB: Point

var slope: float

var ray_width: float
var ray_color: Color
var obj_name: String

enum {
	DIRECTION_FORWARD = 1,
	DIRECTION_BACKWARD = -1,
	DIRECTION_UP = 1,
	DIRECTION_DOWN = -1
}

func _init(a: Point, b: Point, color = Color.RED):
	self.pointA = a
	self.pointB = b
	
	self.slope = float(pointA.y - pointB.y) / float(pointA.x - pointB.x)
	
	self.ray_color = color
	self.obj_name = "→" + a.obj_name + b.obj_name
	self.name = self.obj_name

	var cam_zoom = Global.RootNode.cam_zoom
	self.ray_width = 5.0 / cam_zoom.x
	Global.RootNode.add_child(self)


func _ready():
	var line2d = Line2D.new()
	
	line2d.add_point(Vector2(pointA.x, -pointA.y))
	line2d.add_point(Vector2(pointB.x, -pointB.y))
	
	if self.direction().x == DIRECTION_FORWARD:
		var coords = self.to_line().coords_at_x("X", Global.RootNode.graph_bounds.x).get_coordinates()
		line2d.add_point(Vector2(coords.x, -coords.y))
		
	elif self.direction().x == DIRECTION_BACKWARD:
		var coords = self.to_line().coords_at_x("X", Global.RootNode.graph_start.x).get_coordinates()
		line2d.add_point(Vector2(coords.x, -coords.y))
	
	line2d.width = ray_width
	line2d.default_color = ray_color
	line2d.name = "Line2D"
	add_child(line2d)


func to_line(visible: bool = false, color = Color.BLUE) -> Line:
	if visible:
		return Line.new(pointA, pointB, color)
	else:
		return Line.new(pointA, pointB, Color(0,0,0,0))


func contains(point: Point) -> bool:
	if is_equal_approx(self.to_line().coords_at_x("X", point.x, Color(0,0,0,0)).y, point.y):
		if self.pointA.x > self.pointB.x and point.x < self.pointA.x: # Ray moves backward
			return true
		
		elif self.pointA.x < self.pointB.x and point.x > self.pointA.x: # Ray moves forward
			return true
	
	return false


func direction() -> Vector2:
	var dirX = 0
	var dirY = 0
	
	if self.pointA.x < self.pointB.x:
		dirX = DIRECTION_FORWARD
	elif self.pointA.x > self.pointB.x:
		dirX = DIRECTION_BACKWARD
	
	if self.pointA.y < self.pointB.y:
		dirY = DIRECTION_UP
	elif self.pointA.y > self.pointB.y:
		dirY = DIRECTION_DOWN
	
	return Vector2(dirX, dirY)


func intersects_line(point_name: String, line: Line, color = Color.RED) -> Point:
	var intersection = self.to_line().intersects_line(point_name, line, color)
	
	if intersection:
		if self.direction().x == DIRECTION_FORWARD and intersection.x > self.pointA.x:
			return intersection
		elif self.direction().x == DIRECTION_BACKWARD and intersection.x < self.pointA.x:
			return intersection
	
	return null


func intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var intersection = self.to_line().intersects_segment(point_name, seg, color)
	
	if intersection:
		if self.direction().x == DIRECTION_FORWARD and intersection.x > self.pointA.x:
			return intersection
		elif self.direction().x == DIRECTION_BACKWARD and intersection.x < self.pointA.x:
			return intersection
	
	return null


func intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point:
	var intersection = self.intersects_line(point_name, ray.to_line(), color)
	
	if intersection:
		if ray.direction().x == DIRECTION_FORWARD and intersection.x > ray.pointA.x:
			return intersection
		elif ray.direction().x == DIRECTION_BACKWARD and intersection.x < ray.pointA.x:
			return intersection
	
	return null


func bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var intersection = self.intersects_segment(point_name, seg, color)
	
	if intersection and intersection.is_same_as(seg.get_midpoint("X")):
		return intersection
	
	return null


func is_opposite_of(ray: Ray) -> bool:
	var same_endpoint = ray.pointA.is_same_as(self.pointA)
	var opposite_direction = self.pointA.is_collinear_to(self.pointB, ray.pointB)
	
	if same_endpoint and opposite_direction:
		return true
	
	return false


func is_same_as(obj) -> bool:
	if obj is Ray and self.pointA.is_same_as(obj.pointA) and is_equal_approx(self.slope, obj.slope):
		return true
	else:
		return false


func is_parallel_to(obj) -> bool:
	var is_valid_type = obj is Line or obj is Segment or obj is Ray
	
	if is_valid_type and is_equal_approx(self.slope, obj.slope) and !self.is_same_as(obj):
		return true
	
	return false


func is_perpendicular_to(obj) -> bool:
	var opposite_reciprocal = -(1/self.slope)
	var is_valid_type = obj is Line or obj is Segment or obj is Ray
	
	if is_valid_type and is_equal_approx(obj.slope, opposite_reciprocal):
		return true
	
	return false


func is_transversal_of(obj1, obj2) -> bool:
	var inter1: Point
	var inter2: Point
	
	if obj1 is Line:
		inter1 = self.intersects_line("X", obj1, Color(0,0,0,0))
	elif obj1 is Segment:
		inter1 = self.intersects_segment("X", obj1, Color(0,0,0,0))
	elif obj1 is Ray:
		inter1 = self.intersects_ray("X", obj1, Color(0,0,0,0))
	
	
	if obj2 is Line:
		inter2 = self.intersects_line("X", obj2, Color(0,0,0,0))
	elif obj2 is Segment:
		inter2 = self.intersects_segment("X", obj2, Color(0,0,0,0))
	elif obj2 is Ray:
		inter2 = self.intersects_ray("X", obj2, Color(0,0,0,0))
	
	
	if inter1 and inter2:
		if !inter1.is_same_as(inter2):
			return true
	
	return false
