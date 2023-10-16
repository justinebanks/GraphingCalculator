class_name AlgebraicExpression extends Node

var expression: String
var obj_name: String

func _init(expression):
	if !(expression is String):
		expression = str(expression)
	
	self.expression = expression
	self.obj_name = "Expression"


func simplify():
	var output = []
	OS.execute("python", ["kanu.py", expression], output)
	return AlgebraicExpression.new(output)


func solve_linear_equation():
	pass

