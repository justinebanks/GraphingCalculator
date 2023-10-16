extends Node2D

# Fix: Undefined Slopes (Line.gd function get_slope and constructor)
# Finish: Angle Bisection (Line.gd Line 159)

# Add: Proofs
# Add: Triangles
# Add: Polygons (Quadrilateral, Pentagon, Hexagon, ...)

# Camera Scale    Pixel Size       
# 1             = (1150, 650)    = 0.5    = 5.0
# 2             = (575, 325)     = 0.25   = 2.5
# 5             = (230, 130)     = 0.01   = 1.0
# 10            = (115, 65)      = 0.005  = 0.5
# 25            = (46, 26)       = 0.002  = 0.2
# 50            = (23, 13)       = 0.001  = 0.1

@onready var Camera = $Camera2D

@onready var is_fullscreen = false
@onready var graph_bounds = Vector2(50, 50) # SIze of the graph
@onready var graph_start = Vector2(0.0, 0.0) # Bottom Left Camera Corner Coordinates (In Graph Terms)

@onready var cam_zoom = Vector2(1150 / graph_bounds.x, 650 / graph_bounds.y)

func _ready():
	Global.RootNode = self
	
	var og_start = self.graph_start
	show_graph_bounds()
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
		self.graph_start.y = self.graph_start.y + self.graph_bounds.y * 0.65
		self.cam_zoom.x *= 2.35
		self.cam_zoom.y *= 2.35

	Camera.zoom = self.cam_zoom
	Camera.position.x = self.graph_start.x
	Camera.position.y = ((650 / self.cam_zoom.y) * -1) - self.graph_start.y
	
	
	var origin = Point.new("X", 0, 0)
	var graph_start = Point.new("X", og_start.x, og_start.y)
	var graph_end = Point.new("X", og_start.x + self.graph_bounds.x, og_start.y + self.graph_bounds.y)
	
	
	#linear_pair_example()
	#same_angle_example()
	#intersection_example()
	#vertical_angle_example()
	transversal_example()


func show_graph_bounds():
	var bottom_left = Point.new("X", self.graph_start.x, self.graph_start.y, Color.BLUE)
	var bottom_right = Point.new("X", self.graph_bounds.x + self.graph_start.x, self.graph_start.y, Color.BLUE)
	var top_left = Point.new("X", self.graph_start.x, self.graph_start.y + self.graph_bounds.y, Color.BLUE)
	var top_right = Point.new("X", self.graph_bounds.x + self.graph_start.x, self.graph_bounds.y + self.graph_start.y, Color.BLUE)
	
	Segment.new(bottom_right, bottom_left, Color.BLUE)
	Segment.new(bottom_right, top_right, Color.BLUE)
	Segment.new(top_left, top_right, Color.BLUE)
	Segment.new(bottom_left, top_left, Color.BLUE)


func linear_pair_example():
	var pointA = Point.new("A", 18, 25, Color.YELLOW) # Left
	var pointB = Point.new("B", 25, 25, Color.BLUE) # Vertex
	var pointC = Point.new("C", 32, 25, Color.GREEN) # Right
	var pointD = Point.new("D", 24, 34) # Intersector
	
	var rayBA = Ray.new(pointB, pointA)
	var rayBC = Ray.new(pointB, pointC)
	var rayBD = Ray.new(pointB, pointD)
	
	var angleABD = Angle.new(pointA, pointB, pointD)
	var angleBDC = Angle.new(pointD, pointB, pointC)
	
	print("m∠ABD: ", angleABD.measure())
	print("m∠BDC: ", angleBDC.measure())
	print("m∠ABD + m∠BDC: ", angleABD.measure() + angleBDC.measure())
	print("")
	
	var s1 = Statement.new(angleABD, Statement.SUPPLEMENT_OF, angleBDC)
	print(s1.as_string())
	print(s1.evaluate())
	
	var s2 = Statement.new(angleABD, Statement.ADJACENT_TO, angleBDC)
	print(s2.as_string())
	print(s2.evaluate())
	
	var s3 = Statement.new(angleABD, Statement.LINEAR_PAIR_WITH, angleBDC)
	print(s3.as_string())
	print(s3.evaluate())


func same_angle_example():
	var pointA = Point.new("A", 20, 25)
	var pointB = Point.new("B", 25, 25, Color.ORANGE)
	var pointC = Point.new("C", 30, 31, Color.YELLOW)
	
	var rayBA = Ray.new(pointB, pointA)
	var rayBC = Ray.new(pointB, pointC)
	
	var pointD = Point.new("D", 15, 25, Color.GREEN)
	var pointE = rayBC.to_line(false).coords_at_x("E", 35, Color.PURPLE)
	
	var rayBD = Ray.new(pointB, pointD)
	var rayBE = Ray.new(pointB, pointE)
	
	var angleABC = Angle.new(pointA, pointB, pointC)
	var angleDBE = Angle.new(pointD, pointB, pointE)
	
	var s1 = Statement.new(angleABC, Statement.SAME_AS, angleDBE)
	print(s1.as_string())
	print(s1.evaluate())


func intersection_example():
	var pointA = Point.new("A", 20, 20)
	var pointB = Point.new("B", 30, 24)
	var lineAB = Line.new(pointA, pointB)
	var segAB = Segment.new(pointA, pointB)
	
	var pointC = Point.new("C", 23, 15)
	var pointD = Point.new("D", 29, 27)
	var lineCD = Line.new(pointC, pointD)
	var segCD = Segment.new(pointC, pointD)
	
	var pointE = segAB.intersects_segment("E", segCD)
	
	var s1 = Statement.new(segCD, Statement.INTERSECTS, segAB)
	print(s1.as_string())
	print(s1.evaluate())
	
	var s2 = Statement.new(segCD, Statement.BISECTS, segAB)
	print(s2.as_string())
	print(s2.evaluate())


func vertical_angle_example():
	var pointA = Point.new("A", 20, 20, Color.RED)
	var pointB = Point.new("B", 30, 24, Color.ORANGE)
	var lineAB = Line.new(pointA, pointB)
	
	var pointC = Point.new("C", 23, 15, Color.YELLOW)
	var pointD = Point.new("D", 29, 27, Color.GREEN)
	var lineCD = Line.new(pointC, pointD)
	
	var pointI = lineAB.intersects_line("I", lineCD, Color.BLUE)
	var pointE = Point.new("E", 0, 0, Color.PURPLE)
	
	
	var verts = lineAB.get_vertical_angles(lineCD)
	
	var angle1 = verts["acute"][0]
	var angle2 = verts["acute"][1]
	
	var angle3 = verts["obtuse"][0]
	var angle4 = verts["obtuse"][1]
	
	var s1 = Statement.new(angle3, Statement.CONGRUENT_TO, angle4)
	print(s1.as_string())
	print(s1.evaluate())
	
	var s2 = Statement.new(angle2, Statement.SUPPLEMENT_OF, angle4)
	print(s2.as_string())
	print(s2.evaluate())
	
	var s3 = Statement.new(angle2, Statement.ADJACENT_TO, angle4)
	print(s3.as_string())
	print(s3.evaluate())
	
	print("\n")
	print(angle1.measure())
	print(angle3.measure())


func transversal_example():
	var pointA = Point.new("A", 20, 20, Color.RED)
	var pointB = Point.new("B", 45, 24, Color.ORANGE)
	var lineAB = Line.new(pointA, pointB)
	
	var pointC = Point.new("C", 23, 15, Color.YELLOW)
	var pointD = Point.new("D", 29, 27, Color.GREEN)
	var lineCD = Line.new(pointC, pointD)
	
	var pointE = Point.new("E", 33, 15, Color.PURPLE)
	var pointF = Point.new("F", 39, 27, Color.PINK)
	var lineEF = Line.new(pointE, pointF)
	
	var s1 = Statement.new(lineAB, Statement.TRANSVERSAL_OF, lineCD, lineEF)
	var s2 = Statement.new(lineCD, Statement.TRANSVERSAL_OF, lineAB, lineEF)
	var s3 = Statement.new(lineEF, Statement.TRANSVERSAL_OF, lineCD, lineAB)
	var s4 = Statement.new(lineCD, Statement.PARALLEL_TO, lineEF)
	
	for s in [s1, s2, s3, s4]:
		if s.evaluate() == true:
			print(s.as_string())
	
	
	var trans = Transversal.new(lineAB, lineCD, lineEF)
	var pair = trans.get_alternate_interior_angles()[1]
	
	var s5 = Statement.new(pair[0], Statement.ALTERNATE_INTERIOR_TO, pair[1], trans)
	print(s5.as_string())
	print(s5.evaluate())
	
	var s6 = Statement.new(pair[0], Statement.CONGRUENT_TO, pair[1])
	print(s6.as_string())
	print(s6.evaluate())
	
	print("")
	print(pair[0].measure())
	print(pair[1].measure())
	
	
	

