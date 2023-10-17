# API Documentation

This document is a work in progress

Currently In Progress:
- Expression
- Point
- Line
- Segment
- Ray
- Angle
- Statement
- Transversal

### Expression (In Progress)

|**Properties**|
|---|
|`expression: String`
|`obj_name: String`

|**Methods**|
|---|
|`_init(expression: String)`
|`simplify() -> Expression`

### Point 
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

**Properties**
`pointA: Point`
`pointB: Point`
`y_intercept: float`
`slope: float`
`line_width: float`
`line_color: Color`
`obj_name: String`

**Static Methods**
`static get_line_with_slope(point: Point, slope: float, color: Color = Color.RED) -> Line`

**Methods**
`_init(a: Point, b: Point, color = Color.RED)`
`slope_intercept_form() -> String`
`coords_at_x(point_name: String, x_coord: float, color = Color.RED) -> Point`
`contains(point: Point) -> bool`
`intersects_line(point_name: String, line: Line, color = Color.RED) -> Point`
`intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point`
`bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`is_same_as(obj) -> bool`
`is_parallel_to(obj) -> bool`
`is_perpendicular_to(obj) -> bool`
`bisects_angle(angle: Angle) (In Progress)`
`get_vertical_angles(other_line: Line, intersection_name: String = "I")`
`is_transversal_of(obj1, obj2) -> bool`

## Segment

**Properties**
`pointA: Point`
`pointB: Point`
`slope: float`
`seg_width: float`
`seg_color: Color`
`obj_name: String`

**Methods**
`_init(a: Point, b: Point, color = Color.RED)`
`to_line(is_visible: bool = false, color = Color.BLUE) -> Line`
`contains(point: Point) -> bool`
`get_length() -> float`
`is_congruent_to(seg: Segment) -> bool`
`get_midpoint(point_name: String, color = Color.RED) -> Point`
`intersects_line(point_name: String, line: Line, color = Color.RED) -> Point`
`intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point`
`bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`is_same_as(obj) -> bool`
`is_parallel_to(obj) -> bool`
`is_perpendicular_to(obj) -> bool`
`is_transversal_of(obj1, obj2) -> bool`

## Ray

**Properties**
`pointA: Point`
`pointB: Point`
`slope: float`
`ray_width: float`
`ray_color: Color`
`obj_name: String`

**Enumerations**
```
enum {
	DIRECTION_FORWARD = 1,
	DIRECTION_BACKWARD = -1,
	DIRECTION_UP = 1,
	DIRECTION_DOWN = -1
}
```

**Methods**
`_init(a: Point, b: Point, color = Color.RED)`
`to_line(visible: bool = false, color = Color.BLUE) -> Line`
`contains(point: Point) -> bool`
`direction() -> Vector2`
`intersects_line(point_name: String, line: Line, color = Color.RED) -> Point`
`intersects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`intersects_ray(point_name: String, ray: Ray, color = Color.RED) -> Point`
`bisects_segment(point_name: String, seg: Segment, color = Color.RED) -> Point`
`is_opposite_of(ray: Ray) -> bool`
`is_same_as(obj) -> bool`
`is_parallel_to(obj) -> bool`
`is_perpendicular_to(obj) -> bool`
`is_transversal_of(obj1, obj2) -> bool`

## Angle

**Properties**
`vertex: Point`
`pointA: Point`
`pointB: Point`
`side1: Ray`
`side2: Ray`
`obj_name: String`

**Methods**
`_init(a: Point, vert: Point, b: Point)`
`measure() -> float`
`is_congruent_to(angle: Angle) -> bool`
`is_same_as(angle: Angle) -> bool`
`is_adjacent_to(angle: Angle) -> bool`
`is_complement_of(angle: Angle) -> bool`
`is_supplement_of(angle: Angle) -> bool`
`is_linear_pair(angle: Angle) -> bool`
`is_obtuse() -> bool`
`is_acute() -> bool`
`is_right() -> bool`
`get_vertical_angle() -> bool`

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

