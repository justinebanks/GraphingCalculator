class_name Line extends Node2D

# Info
#	- Slope Intercept Form
#	- Y Coordinates At X

# Comparisons
#	- Intersections (with Lines, Segments, and Rays)
#	- Containing
#	- Parallel & Perpendicular
#	- Is Same As
#	- Bisection (with Segments & Angles)
#	- Is A Transversal of 2 Other Objects (Line, Segment, or Ray)

# Fixes
#	- ANGLE BISECTION IN PROGRESS
#	- UNDEFINED SLOPE ERROR


var pointA: Point
var pointB: Point

var y_intercept: float
var slope: float

var line_width: float
var line_color: Color

var obj_name: String

func _init(a: Point, b: Point, color = Color.RED):
	self.pointA = a
	self.pointB = b
	
	self.slope = float(a.y - b.y) / float(a.x - b.x)
	self.y_intercept = (a.y - (self.slope * a.x))
	
	self.line_color = color
	self.obj_name = "↔" + a.obj_name + b.obj_name
	self.name = self.obj_name
	
	var cam_zoom = Global.RootNode.cam_zoom
	self.line_width = 5.0 / cam_zoom.x
	Global.RootNode.add_child(self)


func _ready():
	var line2d = Line2D.new()
	
	line2d.add_point(Vector2(pointA.x, -pointA.y))
	line2d.add_point(Vector2(pointB.x, -pointB.y))
	line2d.add_point(Vector2(1150, -(1150 * slope + y_intercept)))
	line2d.add_point(Vector2(0, -y_intercept))
	line2d.width = line_width
	line2d.default_color = line_color
	add_child(line2d)


static func get_line_with_slope(point: Point, slope: float, color: Color = Color.RED) -> Line:
	var y_int = point.y - (slope * point.x)
	
	var new_x = 20
	var new_y = slope*new_x + y_int
	var new_point = Point.new("X", new_x, new_y, Color(0,0,0,0))
	
	return Line.new(point, new_point, color)


func slope_intercept_form() -> String:
	return "y = " + str(self.slope) + "x + " + str(self.y_intercept)


func coords_at_x(point_name: String, x_coord: float, color = Color.RED) -> Point:
	var new_y = x_coord * self.slope + self.y_intercept
	return Point.new(point_name, x_coord, new_y, color)


func contains(point: Point) -> bool:
	if point.is_collinear_to(self.pointA, self.pointB):
		return true
	else:
		return false


func intersects_line(point_name: String, line: Line, color = Color.RED) -> Point:
	if self.slope != line.slope:
		var x = ((line.y_intercept - self.y_intercept) / (self.slope - line.slope))
		var y = (self.slope * x + self.y_intercept)
		return Point.new(point_name, x, y, color)
	else:
		return null


func intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var line_for_seg = Line.new(seg.pointA, seg.pointB, Color(0,0,0,0))
	
	if self.intersects_line("X", line_for_seg, Color(0,0,0,0)):
		var intersection = self.intersects_line("X", line_for_seg, Color(0,0,0,0))
		
		if Global.between(intersection.x, seg.pointA.x, seg.pointB.x) and Global.between(intersection.y, seg.pointA.y, seg.pointB.y):
			return self.intersects_line(point_name, line_for_seg, color)
		else:
			return null
	else:
		return null


func intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point:
	return ray.intersects_line(point_name, self, color)


func bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point:
	var intersection = self.intersects_segment(point_name, seg, color)
	var midpoint = seg.get_midpoint("X", Color(0,0,0,0))
	
	if intersection.is_same_as(midpoint):
		return intersection
	else:
		return null


func is_same_as(obj) -> bool:
	if obj is Line and is_equal_approx(obj.slope, self.slope) and is_equal_approx(obj.y_intercept, self.y_intercept):
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


''' IN PROGRESS '''
func bisects_angle(angle: Angle):
	var contains_vertex = self.contains(angle.vertex)
	
	# Find a way of expressing that if the angle is <ABC,
	# then m<ABM = m<MBC


func get_vertical_angles(other_line: Line, intersection_name: String = "I"):
	var intersection = self.intersects_line(intersection_name, other_line, Color(0,0,0,0))
	
	if intersection:
		var result = {}
		
		var angle1 = Angle.new(self.pointA, intersection, other_line.pointA)
		var angle2 = Angle.new(self.pointB, intersection, other_line.pointB)
		
		var angle3 = Angle.new(self.pointA, intersection, other_line.pointB)
		var angle4 = Angle.new(self.pointB, intersection, other_line.pointA)
		
		if angle1.is_acute():
			result = { "acute": [angle1, angle2], "obtuse": [angle3, angle4], "intersection": intersection, "raw": [angle1, angle2, angle3, angle4] }
		elif angle3.is_obtuse():
			result = { "acute": [angle3, angle4], "obtuse": [angle1, angle2], "intersection": intersection, "raw": [angle1, angle2, angle3, angle4] }
		
		return result
	else:
		return null


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
