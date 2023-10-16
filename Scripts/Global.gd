extends Node

var RootNode: Node2D = null

func between(n, a, b):
	# if n is between a and b
	var small = min(a, b)
	var big = max(a, b)
	
	if n >= small and n <= big:
		return true
	else:
		return false
