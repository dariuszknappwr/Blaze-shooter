extends RefCounted
class_name ConveyorPath

enum Edge { BOTTOM, RIGHT, TOP, LEFT }

class Step:
	var grid_pos: Vector2i
	var edge: Edge
	var shoot_dir: Vector2i

var _steps: Array[Step] = []
var speed := 1.0
var shooters_on_conveyor: Array = []
var max_conveyor_shooters := 5
var grid: Grid
var rack: Rack

signal shooter_entered_conveyor(shooter: Shooter)
signal conveyor_full()
signal shooter_completed_path(shooter: Shooter)

func _init(shooter_rack: Rack):
	rack = shooter_rack

func initialize(grid_data: Grid) -> void:
	if !_steps.is_empty():
		return
	
	grid = grid_data
	var grid_size = grid.get_grid_size()
	var width = grid_size.x
	var height = grid_size.y
	
	# BOTTOM (x: 0 -> width-1, y = height)
	for x in range(width):
		_steps.append(_create_step(Vector2i(x, height), Edge.BOTTOM, Vector2i(0,-1)))
	
	# RIGHT (y: height-1 -> 0, x = width)
	for y in range(height -1, -1, -1):
		_steps.append(_create_step(Vector2i(width,y), Edge.RIGHT, Vector2i(-1,0)))
	
	# TOP (x: width-1 -> 0, y = -1)
	for x in range(width -1, -1, -1):
		_steps.append(_create_step(Vector2i(x,-1), Edge.TOP, Vector2i(0,1)))
	
	# Left (x = -1, y: 0 -> height-1)
	for y in range(height):
		_steps.append(_create_step(Vector2i(-1,y), Edge.LEFT, Vector2i(1,0)))

func get_steps() -> Array[Step]:
	return _steps

func _create_step(grid_pos: Vector2i, edge: Edge, shoot_dir: Vector2i) -> Step:
	var s = Step.new()
	s.grid_pos = grid_pos
	s.edge = edge
	s.shoot_dir = shoot_dir
	return s

func get_size():
	return _steps.size()

func get_next_step(shooter: Shooter):
	var next_step = shooter.path_index + 1
	var out_of_array = next_step > _steps.size()
	if out_of_array:
		shooter_completed_path.emit(shooter)
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
	shooter_entered_conveyor.emit(shooter)
	return true

func update_conveyor(delta:float):
	for shooter in shooters_on_conveyor.duplicate():
		_process_shooter_on_conveyor(shooter)

func _process_shooter_on_conveyor(shooter: Shooter)-> void:
	if shooter.has_shot_this_step:
		return;
	
	var target = shooter.find_target(grid)
	if target != Vector2i(-1,-1):
		grid.get_cell(target.x, target.y).hit()
	
	shooter.has_shot_this_step = true

func get_step(index: int) -> Step:
	if index < 0 or index >= _steps.size():
		return null
	return _steps[index]
