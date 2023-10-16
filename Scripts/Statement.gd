class_name Statement extends Node

# Info
#	- Evaluates Statement
#	- Converts Statement to String
#	- Checks If a Statement is Valid
#	- Flipping Statement

# Static Info
#	- Checks For Valid Operations or Comparisons That An Object Can Do
#	- Checks For Valid Operations or Comparisons That Can Be Done To An Object


var object1
var relationship: int
var object2
var object3

enum {
	SAME_AS,
	CONGRUENT_TO,
	ADJACENT_TO,
	PERPENDICULAR_TO,
	PARALLEL_TO,         
	CONTAINS,
	COMPLEMENT_OF,
	SUPPLEMENT_OF,
	OPPOSITE_OF,
	LINEAR_PAIR_WITH,
	
	COLLINEAR_TO,
	TRANSVERSAL_OF,

	INTERSECTS,
	BISECTS,

	CORRESPONDS_TO,
	ALTERNATE_INTERIOR_TO,
	ALTERNATE_EXTERIOR_TO,
	SAMESIDE_INTERIOR_TO,
}


var map_relation = {
	SAME_AS: "is_same_as",
	CONGRUENT_TO: "is_congruent_to",
	ADJACENT_TO: "is_adjacent_to",
	PERPENDICULAR_TO: "is_perpendicular_to",
	PARALLEL_TO: "is_parallel_to",
	CONTAINS: "contains",
	COMPLEMENT_OF: "is_complement_of",
	SUPPLEMENT_OF: "is_supplement_of",
	OPPOSITE_OF: "is_opposite_of",
	LINEAR_PAIR_WITH: "is_linear_pair",
	
	COLLINEAR_TO: "is_collinear_to",
	TRANSVERSAL_OF: "is_transversal_of",
	
	INTERSECTS: "intersects_*",
	BISECTS: "bisects_*",

	CORRESPONDS_TO: "get_corresponding_angles",
	ALTERNATE_INTERIOR_TO: "get_alternate_interior_angles",
	ALTERNATE_EXTERIOR_TO: "get_alternate_exterior_angles",
	SAMESIDE_INTERIOR_TO: "get_sameside_interior_angles",
}


# Have Functions that always return a 'bool' and take in 1 parameters
var param1_boolalways = [SAME_AS, CONGRUENT_TO, ADJACENT_TO, PERPENDICULAR_TO, PARALLEL_TO, CONTAINS, COMPLEMENT_OF, SUPPLEMENT_OF, OPPOSITE_OF, LINEAR_PAIR_WITH]

# Have Functions That Return Either A Point or 'null'
var param1_pointsometimes = [INTERSECTS, BISECTS]

# Have Functions that always return a 'bool' and take in 2 parameters
var param2_boolalways = [COLLINEAR_TO, TRANSVERSAL_OF]

# Have Functions That Are Methods of the 'Transversal' Class
var transversal_relationship = [CORRESPONDS_TO, ALTERNATE_INTERIOR_TO, ALTERNATE_EXTERIOR_TO, SAMESIDE_INTERIOR_TO]


func _init(object1, relationship: int, object2, object3 = null):
	self.object1 = object1
	self.object2 = object2
	self.object3 = object3
	self.relationship = relationship
	
	self.is_valid_statement()
	
	if object2 is Line:
		map_relation[INTERSECTS] = "intersects_line"
	
	elif object2 is Segment:
		map_relation[INTERSECTS] = "intersects_segment"
		map_relation[BISECTS] = "bisects_segment"
	
	elif object2 is Ray:
		map_relation[INTERSECTS] = "intersects_ray"
	
	elif object2 is Angle:
		map_relation[BISECTS] = "bisects_angle"


func get_flipped_statement() -> Statement:
	return Statement.new(self.object2, self.relationship, self.object1)


func evaluate() -> bool:
	self.is_valid_statement()
	
	if self.relationship in param1_pointsometimes:
		var result = self.object1.call(map_relation[self.relationship], "X", object2)
		
		if result != null:
			return true
		else:
			return false
	
	elif self.relationship in param2_boolalways:
		return self.object1.call(map_relation[self.relationship], object2, object3)
	
	elif self.relationship in transversal_relationship:
		var result = self.object3.call(map_relation[self.relationship])
		
		var correct_pair = null
		
		for pair in result:
			if self.object1 in pair and self.object2 in pair:
				correct_pair = pair
		
		if correct_pair != null:
			return true
		else:
			return false
	
	else: # param1_boolalways
		return self.object1.call(map_relation[self.relationship], object2)


func as_string() -> String:
	# ↔→▲∠≤≥≠∘≅⇄≈⊥
	self.is_valid_statement()
	
	var r_text = ""
	var type1 = ""
	var type2 = ""
	
	match self.relationship:
		SAME_AS: r_text = "is the same as"
		CONGRUENT_TO: r_text = "≅"
		ADJACENT_TO: r_text = "is adjacent to"
		PERPENDICULAR_TO: r_text = "⊥"
		PARALLEL_TO: r_text = "||"
		CONTAINS: r_text = "contains"
		COMPLEMENT_OF: r_text = "complements"
		SUPPLEMENT_OF: r_text = "supplements"
		OPPOSITE_OF: r_text = "is an opposite ray of"
		LINEAR_PAIR_WITH: r_text = "is a linear pair with"
		
		INTERSECTS: r_text = "intersects"
		BISECTS: r_text = "bisects"
		
		COLLINEAR_TO: r_text = "is collinear to"
		TRANSVERSAL_OF: r_text = "is a transversal of"
		
		CORRESPONDS_TO: r_text = "corresponds to"
		ALTERNATE_INTERIOR_TO: r_text = "is the alternate interior angle to"
		ALTERNATE_EXTERIOR_TO: r_text = "is the alternate exterior angle to"
		SAMESIDE_INTERIOR_TO: r_text = "is the same-side interior angle to"
	
	
	if self.object3 != null:
		if self.relationship in param2_boolalways:
			return str(self.object1.obj_name) + " " + r_text + " " + str(self.object2.obj_name) + ", " + str(self.object3.obj_name)
			
		elif self.relationship in transversal_relationship:
			var string = str(self.object1.obj_name) + " " + r_text + " " + str(self.object2.obj_name) + " (In the context of " + str(self.object3.transversal.obj_name) + "'s transversing of " + str(self.object3.transversee1.obj_name) + ", " + str(self.object3.transversee2.obj_name) + ")"
			return string
		
		else:
			return ""
	else:
		return self.object1.obj_name + " " + r_text + " " + self.object2.obj_name


func is_valid_statement():
	var invalid_obj1 = !(self.relationship in self.possible_operations1(object1))
	var invalid_obj2 = !(self.relationship in self.possible_operations2(object2))
	var invalid_obj3 = !(self.relationship in self.possible_operations2(object3)) and self.object3 != null and !(self.object3 is Transversal)
	var needs_obj3 = self.relationship in param2_boolalways and self.object3 == null
	var remove_obj3 = self.relationship not in param2_boolalways and self.relationship not in transversal_relationship and self.object3 != null
	var invalid_obj3_for_transversal = self.relationship in transversal_relationship and !(self.object3 is Transversal)
	
	if needs_obj3:
		print("Error: This Relationship Requires An 'object3' parameter, but did not get one")
		return false
	
	if remove_obj3:
		print("Error: This Relationship Should Not Make Use of Object 3, remove that parameter")
		return false
	
	if invalid_obj1:
		print("Error: Invalid Relationship For Object 1")
		return false
	
	if invalid_obj2:
		print("Error: Invalid Relationship For Object 2")
		return false

	if invalid_obj3:
		print("Error: Invalid Relationship For Object 3")
		return false
	
	return true


# Possible Opperations if 'object' is object1 of the Statement's contructor
static func possible_operations1(object) -> Array:
	if object is Point:
		return [COLLINEAR_TO, SAME_AS]
	
	elif object is Line:
		return [TRANSVERSAL_OF, INTERSECTS, CONTAINS, PARALLEL_TO, PERPENDICULAR_TO, SAME_AS, BISECTS]
	
	elif object is Segment:
		return [TRANSVERSAL_OF, INTERSECTS, CONTAINS, SAME_AS, BISECTS, CONGRUENT_TO, PARALLEL_TO, PERPENDICULAR_TO]
	
	elif object is Ray:
		return [TRANSVERSAL_OF, CONTAINS, INTERSECTS, BISECTS, SAME_AS, OPPOSITE_OF, PARALLEL_TO, PERPENDICULAR_TO]

	elif object is Angle:
		return [CONGRUENT_TO, ADJACENT_TO, COMPLEMENT_OF, SUPPLEMENT_OF, SAME_AS, LINEAR_PAIR_WITH, CORRESPONDS_TO, ALTERNATE_EXTERIOR_TO, ALTERNATE_INTERIOR_TO, SAMESIDE_INTERIOR_TO]
	else:
		return []


# Possible Operations if 'object' is object2 of the Statement's constructor
static func possible_operations2(object) -> Array:
	if object is Point:
		return [COLLINEAR_TO, SAME_AS, CONTAINS]
	
	elif object is Line:
		return [TRANSVERSAL_OF, INTERSECTS, PARALLEL_TO, PERPENDICULAR_TO, SAME_AS]
	
	elif object is Segment:
		return [TRANSVERSAL_OF, INTERSECTS, CONTAINS, SAME_AS, BISECTS, CONGRUENT_TO, PARALLEL_TO, PERPENDICULAR_TO]
	
	elif object is Ray:
		return [TRANSVERSAL_OF, INTERSECTS, SAME_AS, OPPOSITE_OF, PARALLEL_TO, PERPENDICULAR_TO]

	elif object is Angle:
		return [CONGRUENT_TO, ADJACENT_TO, COMPLEMENT_OF, SUPPLEMENT_OF, SAME_AS, LINEAR_PAIR_WITH, CORRESPONDS_TO, ALTERNATE_EXTERIOR_TO, ALTERNATE_INTERIOR_TO, SAMESIDE_INTERIOR_TO]
	else:
		return []



