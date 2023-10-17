# GraphingCalculator

A graphing calculator created using the Godot 4 game engine

**Class API References**
- [Expression (In Progress)](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Point](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Line](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Segment](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Ray](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Angle](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Statement](https://github.com/justinebanks/GraphingCalculator/API.md)
- [Transversal](https://github.com/justinebanks/GraphingCalculator/API.md)

## Quick Start
The main endpoint of the program is [graph.gd](https://github.com/justinebanks/GraphingCalculator/Scripts/graph.gd)
In the `_ready()` function, simply write a function for where your executed code will go

```gdscript
func _ready():
    ...
    ...
    ...
    
	var origin = Point.new("X", 0, 0)
	var graph_start = Point.new("X", og_start.x, og_start.y)
	var graph_end = Point.new("X", og_start.x + self.graph_bounds.x, og_start.y + self.graph_bounds.y)
	
	#linear_pair_example()
	#same_angle_example()
	#intersection_example()
	#vertical_angle_example()
	
	new_example()

# Function where all your executed code will go
func new_example():
    pass

```

In the function for your new example, you can create points, lines, and other common
geometric objects as variables and perform operations on them

```
func new_example():
    var pointA = Point.new("A", 20, 20, Color.ORANGE)
    var pointB = Point.new("B", 25, 25, Color.ORANGE)
    var segAB = Segment.new(pointA, pointB, Color.ORANGE)

    var pointC = Point.new("A", 28, 28, Color.GREEN)
    var pointD = Point.new("B",33, 33, Color.GREEN)
    var segCD = Segment.new(pointC, pointD, Color.GREEN)
    
    print(segAB.is_congruent_to(segCD)) # returns true
    print(segAB.get_length())
    
    var pointE = segAB.get_midpoint("E")
    
```

The complexity of this function will increase as you
start using more complex objects and perform more complex operations
