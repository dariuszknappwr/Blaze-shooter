extends RefCounted
class_name ConveyorPath
@export var speed: float
enum Edge { BOTTOM, RIGHT, TOP, LEFT }

class Step:
	var grid_pos: Vector2i
	var edge: Edge
	var shoot_dir: Vector2i

func build(width: int, height: int) -> Array[Step]:
	var steps: Array[Step] = []
	
	# BOTTOM (x: 0 -> width-1, y = height)
	for x in range(width):
		var s = Step.new()
		s.grid_pos = Vector2i(x, height)
		s.edge = Edge.BOTTOM
		s.shoot_dir = Vector2i(0, -1)
		steps.append(s)
	
	# RIGHT (y: height-1 -> 0, x = width)
	for y in range(height -1, -1, -1):
		var s = Step.new()
		s.grid_pos = Vector2i(width, y)
		s.edge = Edge.RIGHT
		s.shoot_dir = Vector2i(-1, 0)
		steps.append(s)
	
	# TOP (x: width-1 -> 0, y = -1)
	for x in range(width -1, -1, -1):
		var s = Step.new()
		s.grid_pos = Vector2i(x, -1)
		s.edge = Edge.TOP
		s.shoot_dir = Vector2i(0,1)
		steps.append(s)
	
	# Left (x = -1, y: 0 -> height-1)
	for y in range(height):
		var s = Step.new()
		s.grid_pos = Vector2i(-1, y)
		s.edge = Edge.LEFT
		s.shoot_dir = Vector2i(1,0)
		steps.append(s)
	
	return steps
