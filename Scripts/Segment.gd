class_name Segment extends Node2D

# Info
#	- Length
#	- Midpoint
#	- Slope

# Comparisons
#	- Intersections (with Lines, Segments, and Rays)
#	- Containing
#	- Is Same As
#	- Bisection (with Segments & Angles)
#	- Congruence
#	- Parallel and Perpendicular To
#	- Is Transversal Of

# Fixes
#	- ANGLE BISECTION


var pointA: Point
var pointB: Point

var slope: float

var seg_width: float
var seg_color: Color

var obj_name: String

func _init(a: Point, b: Point, color = Color.RED):
	self.pointA = a
	self.pointB = b
	
	self.slope = float(a.y - b.y) / float(a.x - b.x)
	
	self.seg_color = color
	self.obj_name = "Segment " + a.obj_name + b.obj_name
	self.name = self.obj_name

	var cam_zoom = Global.RootNode.cam_zoom
	self.seg_width = 5.0 / cam_zoom.x
	Global.RootNode.add_child(self)


func _ready():
	var line2d = Line2D.new()
	
	line2d.add_point(Vector2(self.pointA.x, -self.pointA.y))
	line2d.add_point(Vector2(self.pointB.x, -self.pointB.y))
	line2d.width = seg_width
	line2d.default_color = seg_color
	add_child(line2d)


func to_line(is_visible: bool = false, color = Color.BLUE) -> Line:
	if is_visible:
		return Line.new(self.pointA, self.pointB, color)
	else:
		return Line.new(self.pointA, self.pointB, Color(0,0,0,0))


func contains(point: Point) -> bool:
	if point.is_collinear_to(self.pointA, self.pointB) and Global.between(point.y, self.pointA.y, self.pointB.y):
		return true
	else:
		return false


func get_length() -> float:
	return self.pointA.distance_to(self.pointB)


func is_congruent_to(seg: Segment) -> bool:
	if is_equal_approx(self.get_length(), seg.get_length()):
		return true
	else:
		return false


func get_midpoint(point_name: String, color = Color.RED) -> Point:
	var smallX = min(pointA.x, pointB.x)
	var bigX = max(pointA.x, pointB.x)
	
	var smallY = min(pointA.y, pointB.y)
	var bigY = max(pointA.y, pointB.y)
	
	var midX = smallX + (abs(smallX - bigX) / 2)
	var midY = smallY + (abs(smallY - bigY) / 2)

	return Point.new(point_name, midX, midY, color)



func intersects_line(point_name: String, line: Line, color = Color.RED) -> Point:
	return line.intersects_segment(point_name, self, color)


func intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var line_intersection = self.to_line().intersects_segment("X", seg, Color(0,0,0,0))
	
	var self_crosses = (
		(Global.between(self.pointA.x, seg.pointA.x, seg.pointB.x) or Global.between(self.pointA.y, seg.pointA.y, seg.pointB.y))
		or 
		(Global.between(self.pointB.x, seg.pointA.x, seg.pointB.x) or Global.between(self.pointB.y, seg.pointA.y, seg.pointB.y))
	)
	
	var seg_crosses = (
		(Global.between(seg.pointA.x, self.pointA.x, self.pointB.x) or Global.between(seg.pointA.y, self.pointA.y, self.pointB.y))
		or
		(Global.between(seg.pointB.x, self.pointA.x, self.pointB.x) or Global.between(seg.pointB.y, self.pointA.y, self.pointB.y))
	)
	
	if line_intersection != null and self_crosses and seg_crosses:
		return self.to_line().intersects_segment(point_name, seg, color)
	
	return null


func intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point:
	return ray.intersects_segment(point_name, self, color)


func bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var intersection = self.intersects_segment(point_name, seg, color)
	var midpoint = seg.get_midpoint("X", Color(0,0,0,0))
	
	if intersection == null:
		return null
	elif midpoint.is_same_as(intersection):
		return intersection
	else:
		return null


func bisects_angle(angle: Angle) -> bool:
	var contains_vertex = self.contains(angle.vertex)
	
	var angle1 = Angle.new(self.pointA, angle.vertex, angle.pointA)
	var angle2 = Angle.new(self.pointA, angle.vertex, angle.pointB)
	
	var angle3 = Angle.new(self.pointB, angle.vertex, angle.pointA)
	var angle4 = Angle.new(self.pointB, angle.vertex, angle.pointB)
	
	if contains_vertex and (angle1.is_congruent_to(angle2) or angle3.is_congruent_to(angle4)):
		return true
	else:
		return false


func is_same_as(obj) -> bool:
	if obj is Segment and is_equal_approx(self.get_length(), obj.get_length()) and is_equal_approx(self.slope, obj.slope) and is_equal_approx(self.to_line().y_intercept, obj.to_line().y_intercept):
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
