class_name Angle extends Node

# Info
#	- Angle Measure
#	- Is Acute, Obtuse, or Right

# Comparisons
#	- Is Congruent To
#	- Is Adjacent To
#	- Is Complement Of
#	- Is Supplement Of
#	- Is Linear Pair With
#	- Is Same As


var vertex: Point
var pointA: Point
var pointB: Point

var side1: Ray
var side2: Ray

var obj_name: String

func _init(a: Point, vert: Point, b: Point):
	self.vertex = vert
	self.pointA = a
	self.pointB = b
	
	self.side1 = Ray.new(vertex, pointA)
	self.side2 = Ray.new(vertex, pointB)
	
	self.obj_name = "∠" + a.obj_name + vert.obj_name + b.obj_name


func measure() -> float:
	var slope1 = side1.to_line().slope
	var slope2 = side2.to_line().slope
	
	var deg1 = rad_to_deg(atan(slope1))
	var deg2 = rad_to_deg(atan(slope2))
	
	if side1.direction().x == side2.direction().x and side1.direction().y == side2.direction().y:
		return abs(deg1 - deg2)
	
	elif side1.direction().x == side2.direction().x and side1.direction().y != side2.direction().y:
		return abs(deg1 - deg2)
	
	elif side1.direction().x != side2.direction().x and side1.direction().y == side2.direction().y:
		var smallDeg = min(deg1, deg2) + 180
		var bigDeg = max(deg1, deg2) 
		return abs(deg1 - deg2)
	
	elif side1.direction().x != side2.direction().x and side1.direction().y != side2.direction().y:
		return 180 - abs(deg1 - deg2)
	
	else:
		return 0


func is_congruent_to(angle: Angle) -> bool:
	if is_equal_approx(self.measure(), angle.measure()):
		return true
	else:
		return false


func is_same_as(angle: Angle) -> bool:
	var same_vertex = self.vertex.is_same_as(angle.vertex)
	var same_measure = is_equal_approx(self.measure(), angle.measure())
	
	var same_side1 = self.side1.is_same_as(angle.side1) and self.side2.is_same_as(angle.side2)
	var same_side2 = self.side1.is_same_as(angle.side2) and self.side2.is_same_as(angle.side1)
	
	if same_vertex and same_measure:
		if same_side1 or same_side2:
			return true
	
	return false


func is_adjacent_to(angle: Angle) -> bool:
	var shares_endpoint = self.vertex.is_same_as(angle.vertex)
	var is_not_same = !self.is_same_as(angle)
	var shares_side1 = self.side1.is_same_as(angle.side1) or self.side1.is_same_as(angle.side2)
	var shares_side2 = self.side2.is_same_as(angle.side1) or self.side2.is_same_as(angle.side2)
	
	if shares_endpoint and is_not_same:
		if shares_side1 or shares_side2:
			return true
	
	return false


func is_complement_of(angle: Angle):
	var combined_measure = self.measure() + angle.measure()
	
	if is_equal_approx(combined_measure, 90.0):
		return true
	else:
		return false


func is_supplement_of(angle: Angle):
	var combined_measure = self.measure() + angle.measure()
	
	if is_equal_approx(combined_measure, 180.0):
		return true
	else:
		return false


func is_linear_pair(angle: Angle):
	if self.is_supplement_of(angle) and self.vertex.is_same_as(angle.vertex):
		return true
	else:
		return false


func is_obtuse():
	if self.measure() > 90:
		return true
	else:
		return false


func is_acute():
	if self.measure() < 90:
		return true
	else:
		return false


func is_right():
	if is_equal_approx(self.measure(), 90):
		return true
	else:
		return false


func get_vertical_angle():
	var lineA = self.side1.to_line()
	var lineB = self.side2.to_line()
	
	var verts = lineA.get_vertical_angles(lineB)
	
	if is_equal_approx(verts[0][0].measure(), self.measure()):
		if verts[0][0].is_same_as(self):
			return verts[0][1]
		else:
			return verts[0][0]
	
	elif is_equal_approx(verts[1][0].measure(), self.measure()):
		if verts[1][0].is_same_as(self):
			return verts[1][1]
		else:
			return verts[1][0]
