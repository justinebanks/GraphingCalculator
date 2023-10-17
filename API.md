# API Documentation

This document is a work in progress

Currently In Progress:
- Expression
- Line
- Segment
- Ray
- Angle
- Statement
- Transversal

## Expression (In Progress)

|**Properties**|
|---|
|`expression: String`
|`obj_name: String`

|**Methods**|
|---|
|`_init(expression: String)`
|`simplify() -> Expression`

## Point 
The constructor for the `Point` object is as follows:
`_init(point_name: String, x: float, y: float, color=Color.RED)`

The `point_name` is the name that the program will use to recognize the point
and name lines, segments, rays, and angles made using that point accordingly.
The other parameters are fairly straightforward.

```gdscript
var pointA = Point.new("A", 0, 0)
var pointB = Point.new("B", 10, 10)
var pointC = Point.new("C", 20, 20)

# Retuns whether points A, B, and C are collinear
pointA.is_collinear_to(pointB, pointC)
```

|Properties|Description|
|----------|-----------|
|`x: float`|X-value of the `Point`|
|`y: float`|Y value of the `Point`|
|`point_color: Color`|Color of the point (using Godot's builtin `Color`)|
|`obj_name: String`|The `point_name` used in the constructor. Once again, this is the name that the program will use to recognize the point and name lines, segments, rays, and angles made using that point accordingly|


|Methods|Description|
|-------|-----------|
|`is_collinear_to(a: Point, b: Point) -> bool`|Returns true if points a, b, & c are collinear|
|`distance_to(point: Point) -> float`|Returns the distance between two `Point` objects|
|`get_coordinates() -> Vector2`|Returns the coordinates of the `Point` in Godot's builtin `Vector2` type|
|`is_same_as(point: Point) -> bool`|Returns true if the 2 points are the same point|

## Line

Constructor: `_init(a: Point, b: Point, color = Color.RED)`.
`a` and `b` are the 2 points required to create the line and `color` is the color that is given to the line that is automatically drawn between these 2 points

```gdscript
var pointA = Point.new("A", 0, 0)
var pointB = Point.new("B", 10, 10)
var pointC = Point.new("C", 20, 20)

var lineAB = Line.new(pointA, pointB)

# Returns whether line AB contains pointC
lineAB.contains(pointC) # true
```

|Properties|Description|
|----------|-----------|
|`pointA: Point`|The first point given to create the `Line`|
|`pointB: Point`|The second point given to create the `Line`|
|`y_intercept: float`|The Y-Intercept of the line|
|`slope: float`|The slope of the line|
|`line_width: float`|The width the line is drawn with. Wasn't meant to be changed. DON'T CHANGE|
|`line_color: Color`|The color of the line automatically drawn between the 2 given points|
|`obj_name: String`|The name that the program uses to recognize this line (Based on the `obj_name` properties of the 2 `Point` objects passed to the constructor)|

**Static Methods**
`static get_line_with_slope(point: Point, slope: float, color: Color = Color.RED) -> Line`

|Methods|Description|
|-------|-----------|
|`slope_intercept_form() -> String`|Returns the slope-intercept form of the line|
|`coords_at_x(point_name: String, x_coord: float, color = Color.RED) -> Point`|Returns the `Point` corresponding to the given X-Value|
|`contains(point: Point) -> bool`|Returns true if the line contains the given point|
|`intersects_line(point_name: String, line: Line, color = Color.RED) -> Point`|Returns the point of intersection with the given line (null if they don't intersect)|
|`intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`|Returns the point of intersection with the given segment (null if they don't intersect)|
|`intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point`|Returns the point of intersection with the given ray (null if they don't intersect)|
|`bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`|Returns the point of bisection with the given segment (null if they it doesn't bisect it)|
|`is_same_as(obj) -> bool`|Returns true if the 2 objects are the same|
|`is_parallel_to(obj) -> bool`|Returns true if the 2 objects are parallel to each other|
|`is_perpendicular_to(obj) -> bool`|Returns true if the 2 objects are perpendicular to each other|
|`bisects_angle(angle: Angle) (In Progress)`|Returns true if the the line bisects the given angle|
|`get_vertical_angles(other_line: Line, intersection_name: String = "I")`||
|`is_transversal_of(obj1, obj2) -> bool`|Returns true if the line intersects the 2 given objects at different points|

### Vertical Angles

```gdscript
var verts = lineAB.get_vertical_angles(lineCD)

# Returns array for the pair of acute vertical angles formed from the intersection
var acutes = verts["acute"]

var angle1 = acutes[0]
var angle2 = acutes[1]

angle1.is_congruent_to(angle2) # true (because vertical angles are congruent)
```

The structure of the `Dictionary` returned is as follows:
```gdscript
{
    "acute": [Angle1, Angle2]
    "obtuse": [Angle3, Angle4]
    "intersection": Point,
    "raw": [Angle1, Angle2, Angle3, Angle4]
}
```

The "acute" key holds the pair of acute vertical angles and the "obtuse" key holds the pair of obtuse vertical angles. The intersection is the intersection of the 2 lines given.

The "raw" key just returns an array of the 4 angles created by the intersection of the 2 lines. The first and second values are congruent and so are the third and fourth.

```gdscript
var verts = lineAB.get_vertical_angles(lineCD)

verts["raw"][0].is_congruent_to(verts["raw"][1]) # true
verts["raw"][2].is_congruent_to(verts["raw"][3]) # true

```

## Segment
Many properties and methods of Segments and Rays are shared with Lines

`Segment` objects have all the methods of the `Line` object except `coords_at_x()`, `slope_intercept_form()`, and `get_vertical_angles()`

A few methods that the `Segment` object has, but not the `Line` are `get_length()`, `get_midpoint()`, `is_congruent_to()`, and `to_line()`

Properties that it doesn't have are the `y-intercept` and it has `seg_width` and `seg_color` rather than `line_width` and `line_color`


|Methods|Description|
|------|------------|
|`to_line(is_visible: bool = false, color = Color.BLUE) -> Line`|Returns the Line corresponding to the segment (Useful for accessing functionality only available to lines)|
|`get_length() -> float`|Returns the length of the segment|
|`is_congruent_to(seg: Segment) -> bool`|Returns true if the segment is congruent to the given segment|
|`get_midpoint(point_name: String, color = Color.RED) -> Point`|Returns the `Point` that is the midpoint of the segment|

## Ray
Also shares most of the properties and methods of the `Line` object except for `coords_at_x()`, `slope_intercept_form()`, and `get_vertical_angles()`, and `y_intercept`

Similarly to the `Segment` the property names for width and color are related to the class name: `ray_width` and `ray_color`

New functions introduced that are different from the `Line` class are as follows:

|Methods|Description|
|-------|-----------|
|`to_line(visible: bool = false, color = Color.BLUE) -> Line`|Returns the `Line` corresponding to the `Ray`|
|`is_opposite_of(ray: Ray) -> bool`|Returns true if the given `Ray` is an 'opposite ray' of `self`|
|`direction() -> Vector2`|Returns one of the 4 directions of mentioned in the following enumeration|

```gdscript
enum {
	DIRECTION_FORWARD = 1,
	DIRECTION_BACKWARD = -1,
	DIRECTION_UP = 1,
	DIRECTION_DOWN = -1
}
```


## Angle
Contructor: `_init(a: Point, vert: Point, b: Point)`

|Properties|Description|
|----------|-----------|
|`vertex: Point`|Vertex of the angle|
|`pointA: Point`|One point of the angle|
|`pointB: Point`|Another point of the angle|
|`side1: Ray`|The side of the angle containing `pointA` and the `vertex`|
|`side2: Ray`|The side of the angle containing `pointB` and the `vertex`|
|`obj_name: String`|The name of the angle based on the `obj_name` property of the 3 points given in the constructor|

|Methods|Description|
|-------|-----------|
|`measure() -> float`|Returns the measure of the angle|
|`is_congruent_to(angle: Angle) -> bool`|Returns true if the angle is congruent to the given angle|
|`is_same_as(angle: Angle) -> bool`|Returns true if the angle is the same as the given angle|
|`is_adjacent_to(angle: Angle) -> bool`|Returns true if the angle is adjacent to the given angle|
|`is_complement_of(angle: Angle) -> bool`|Returns true if the angle is complementary to the given angle|
|`is_supplement_of(angle: Angle) -> bool`|Returns true if the angle is supplementary to the given angle|
|`is_linear_pair(angle: Angle) -> bool`|Returns true if the angle and the given angle are a linear pair (adjacent and supplementary)|
|`is_obtuse() -> bool`|Returns true if the angle is obtuse|
|`is_acute() -> bool`|Returns true if the angle is acute|
|`is_right() -> bool`|Returns true if the angle is right|
|`get_vertical_angle() -> bool`|Returns the angle that is vertical to `self` |

## Statement

**Properties**
`object1`
`relationship: int`
`object2`
`object3`

**Enumerations**
```
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
```
**Static Methods**
`possible_operations1(object) -> Array`
`possible_operations2(object) -> Array`

**Methods**
`_init(object1, relationship: int, object2, object3 = null)`
`get_flipped_statement() -> Statement`
`evaluate() -> bool`
`as_string() -> String`
`is_valid_statement() -> bool`

## Transversal

**Properties**
`transversal`
`transversee1`
`transversee2`
`vertical1: Dictionary`
`vertical2: Dictionary`

**Methods**
`_init(transversal, of1, of2)`
`get_corresponding_angles()`
`get_alternate_exterior_angles()`
`get_alternate_interior_angles()`
`get_sameside_interior_angles()`

