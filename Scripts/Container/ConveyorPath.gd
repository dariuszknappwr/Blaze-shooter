extends RefCounted
class_name ConveyorPath

var _steps: Array[Step] = []
var speed := 1.0
var shooters_on_conveyor: Array[ConveyorShooterState] = []
var max_conveyor_shooters := 5
var grid: Grid

signal shooter_entered_conveyor(shooter: Shooter)
signal conveyor_full()
signal shooter_completed_path(shooter: Shooter)

func initialize(grid_data: Grid) -> void:
	if !_steps.is_empty():
		return
	
	grid = grid_data
	var grid_size = grid.get_grid_size()
	var width = grid_size.x
	var height = grid_size.y
	
	# BOTTOM (x: 0 -> width-1, y = height)
	for x in range(width):
		_steps.append(_create_step(Vector2i(x, height), Step.Edge.BOTTOM, Vector2i(0,-1)))
	
	# RIGHT (y: height-1 -> 0, x = width)
	for y in range(height -1, -1, -1):
		_steps.append(_create_step(Vector2i(width,y), Step.Edge.RIGHT, Vector2i(-1,0)))
	
	# TOP (x: width-1 -> 0, y = -1)
	for x in range(width -1, -1, -1):
		_steps.append(_create_step(Vector2i(x,-1), Step.Edge.TOP, Vector2i(0,1)))
	
	# Left (x = -1, y: 0 -> height-1)
	for y in range(height):
		_steps.append(_create_step(Vector2i(-1,y), Step.Edge.LEFT, Vector2i(1,0)))

func get_steps() -> Array[Step]:
	return _steps

func _create_step(grid_pos: Vector2i, edge: Step.Edge, shoot_dir: Vector2i) -> Step:
	var s = Step.new()
	s.grid_pos = grid_pos
	s.edge = edge
	s.shoot_dir = shoot_dir
	return s

func get_size():
	return _steps.size()

func _advance_shooter(shooter: Shooter):
	var state = _get_shooter_state(shooter)
	if state:
		var next_step = state.get_next_step_index()
		var out_of_array = next_step >= get_size()
		if out_of_array:
			shooter_completed_path.emit(shooter)
			return
		state.advance()

func _current_step(shooter: Shooter):
	if _steps.is_empty():
		return null
	var state = _get_shooter_state(shooter)
	return _steps[state.path_index]

func can_put_shooter_on_conveyor(shooter: Shooter) -> bool:
	if shooters_on_conveyor.size() >= max_conveyor_shooters:
		return false
	return true

func put_shooter_on_conveyor(shooter: Shooter):
	if !can_put_shooter_on_conveyor(shooter):
		return
	_add_shooter_state_to_conveyor(shooter)
	shooter_entered_conveyor.emit(shooter)

func update_conveyor(delta:float):
	for state in shooters_on_conveyor.duplicate():
		state.time_since_last_step += delta
		if state.time_since_last_step >= state.step_interval:
			_process_shooter_state_on_conveyor(state)

func _process_shooter_state_on_conveyor(state: ConveyorShooterState)-> void:
	var shooter = state.shooter
	_try_shoot(shooter)
	_advance_shooter(shooter)
	state.time_since_last_step = 0
	
	

func _try_shoot(shooter: Shooter):
	var state = _get_shooter_state(shooter)
	if state.has_shot_this_step:
		return;
	var target = find_target(shooter)
	if target != Vector2i(-1,-1):
		grid.get_cell(target.x, target.y).hit()
	
	state.has_shot_this_step = true

func get_step(index: int) -> Step:
	if index < 0 or index >= _steps.size():
		return null
	return _steps[index]

func _add_shooter_state_to_conveyor(shooter: Shooter):
	var state: ConveyorShooterState = ConveyorShooterState.new(shooter)
	shooters_on_conveyor.append(state)

func _get_shooter_state(shooter: Shooter):
	var state: ConveyorShooterState
	for s in shooters_on_conveyor:
		if s.shooter == shooter:
			state = s
			break
	return state

func find_target(shooter: Shooter) -> Vector2i:
	var step = _current_step(shooter)
	if step == null:
		return Vector2i(-1,-1)
	return ShooterTargetFinder.find_target_from_step(step, shooter.color_symbol, grid)

func get_shooters_on_conveyor() -> Array[Shooter]:
	var shooters: Array[Shooter]
	for state in shooters_on_conveyor:
		shooters.append(state.shooter)
	return shooters

func get_states_on_conveyor() -> Array[ConveyorShooterState]:
	return shooters_on_conveyor

func remove_shooter_from_conveyor(shooter: Shooter):
	var state = _get_shooter_state(shooter)
	print(shooters_on_conveyor)
	shooters_on_conveyor.erase(state)
	print(shooters_on_conveyor)
