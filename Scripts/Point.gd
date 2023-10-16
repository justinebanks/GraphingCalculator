class_name Point extends Node2D

# Info
#	- Coordinates
#	- Distance Between Points
#	- Vertical Angles That The Line Forms

# Comparisons
#	- Is Collinear To
#	- Is Same As


var x: float
var y: float
var point_color: Color

var obj_name: String

func _init(name: String, pointX: float, pointY: float, color = Color.RED):
	self.x = float(pointX)
	self.y = float(pointY)
	
	self.position.x = pointX
	self.position.y = -pointY
	
	self.point_color = color
	self.obj_name = name
	self.name = name
	
	var cam_zoom = Global.RootNode.cam_zoom
	self.scale = Vector2(0.9 / cam_zoom.x, 0.9 / cam_zoom.y) 
	Global.RootNode.add_child(self)


func _ready():
	var sprite = Sprite2D.new()
	
	sprite.scale = Vector2(0.05, 0.05)
	sprite.modulate = point_color
	sprite.texture = load("res://white.png")
	sprite.name = "CircleSprite"
	add_child(sprite)


func is_collinear_to(a: Point, b: Point) -> bool:
	var slope1 = float(a.y - b.y) / float(a.x - b.x) # Slope of line AB
	var slope2 = float(a.y - self.y) / float(a.x - self.x) # Slope of line AC (Note that point C refers to 'self')
	
	if is_equal_approx(slope1, slope2):
		return true
	else:
		return false


func distance_to(point: Point) -> float:
	# a^2 + b^2 = c^2
	var a = self.x - point.x
	var b = self.y - point.y
	var c = sqrt(pow(a, 2) + pow(b, 2))
	return c


func get_coordinates() -> Vector2:
	return Vector2(self.x, self.y)


func is_same_as(point: Point) -> bool:
	if is_equal_approx(self.x, point.x) and is_equal_approx(self.y, point.y):
		return true
	
	return false

