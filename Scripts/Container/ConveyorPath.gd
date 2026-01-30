extends RefCounted
class_name ConveyorPath

enum Edge { BOTTOM, RIGHT, TOP, LEFT }

class Step:
	var grid_pos: Vector2i
	var edge: Edge
	var shoot_dir: Vector2i

var steps: Array[Step] = []
var speed := 1.0
var shooters_on_conveyor: Array = []
var max_conveyor_shooters := 5
var grid: Grid
var rack: Rack

signal shooter_added_to_conveyor(shooter: Shooter)
signal conveyor_full()
signal shooter_completed_rotation(shooter: Shooter)

func _init(shooter_rack: Rack):
	rack = shooter_rack

func get_steps(grid_data: Grid) -> Array[Step]:
	if !steps.is_empty():
		return steps
	
	grid = grid_data
	var width = grid.width
	var height = grid.length
	
	# BOTTOM (x: 0 -> width-1, y = height)
	for x in range(width):
		steps.append(_create_step(Vector2i(x, height), Edge.BOTTOM, Vector2i(0,-1)))
	
	# RIGHT (y: height-1 -> 0, x = width)
	for y in range(height -1, -1, -1):
		steps.append(_create_step(Vector2i(width,y), Edge.RIGHT, Vector2i(-1,0)))
	
	# TOP (x: width-1 -> 0, y = -1)
	for x in range(width -1, -1, -1):
		steps.append(_create_step(Vector2i(x,-1), Edge.TOP, Vector2i(0,1)))
	
	# Left (x = -1, y: 0 -> height-1)
	for y in range(height):
		steps.append(_create_step(Vector2i(-1,y), Edge.LEFT, Vector2i(1,0)))
	
	return steps

func _create_step(grid_pos: Vector2i, edge: Edge, shoot_dir: Vector2i) -> Step:
	var s = Step.new()
	s.grid_pos = grid_pos
	s.edge = edge
	s.shoot_dir = shoot_dir
	return s

func get_size():
	return steps.size()

func get_next_step(shooter: Shooter):
	var next_step = shooter.path_index + 1
	var out_of_array = next_step > steps.size()
	if out_of_array:
		shooter_completed_rotation.emit(shooter)
		return
	shooter.advance()
	
		
	

func try_put_shooter_on_conveyor(shooter: Shooter) -> bool:
	if shooters_on_conveyor.size() >= max_conveyor_shooters:
		conveyor_full.emit()
		push_warning("Conveyor full")
		return false
	
	if not rack.remove_shooter_from_top(shooter):
		push_warning("Shooter is not on the top of a column")
		return false
	
	shooters_on_conveyor.append(shooter)
	shooter_added_to_conveyor.emit(shooter)
	return true

func update_conveyor(delta:float):
	for shooter in shooters_on_conveyor:
		
		if not shooter.has_shot_this_step:
			var target = shooter.find_target(grid)
			if target != Vector2i(-1,-1):
				grid.get_cell(target.x, target.y).hit()
			shooter.has_shot_this_step = true
