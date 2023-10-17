class_name Transversal extends Node

# Info
#	- Corresponding Angles
#	- Alternate Exterior Angles
#	- Alternate Interior Angles
#	- Same-Side Interior Angles


var transversal

var transversee1
var transversee2

var vertical1
var vertical2

# (0, 1) and (2, 3) are alternate exterior
# (1, 0) and (3, 2) is alternate interior
# (1, 2) and (3, 0) are same-side interior

func _init(transversal, of1, of2):
	self.transversal = transversal
	
	self.transversee1 = of1
	self.transversee2 = of2
	
	self.vertical1 = transversal.get_vertical_angles(of1)
	self.vertical2 = transversal.get_vertical_angles(of2)
	
	if !transversal.is_transversal_of(of1, of2):
		print("Error: Invalid Transversal Instance")


func get_corresponding_angles():
	var corresponding = [
		[vertical1["raw"][0], vertical2["raw"][0]],
		[vertical1["raw"][1], vertical2["raw"][1]],
		[vertical1["raw"][2], vertical2["raw"][2]],
		[vertical1["raw"][3], vertical2["raw"][3]] ]
	
	return corresponding


func get_alternate_exterior_angles():
	var alternate_exterior = [
		[vertical1["raw"][0], vertical2["raw"][1]],
		[vertical1["raw"][2], vertical2["raw"][3]] ]
	
	return alternate_exterior


func get_alternate_interior_angles():
	var alternate_interior = [ 
		[vertical1["raw"][1], vertical2["raw"][0]],
		[vertical1["raw"][3], vertical2["raw"][2]] ]
	
	return alternate_interior


func get_sameside_interior_angles():
	var sameside_interior = [ 
		[vertical1["raw"][1], vertical2["raw"][2]],
		[vertical1["raw"][3], vertical2["raw"][0]] ]
	
	return sameside_interior
