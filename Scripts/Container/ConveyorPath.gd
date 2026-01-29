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

func get_size():
	return steps.size()

func try_put_shooter_on_conveyor(shooter: Shooter) -> bool:
	for col in rack:
		if col.size() > 0 and col[col.size() -1] == shooter:
			if shooters_on_conveyor.size() >= max_conveyor_shooters:
				push_warning("Conveyor full")
				return false
			
			col.pop_back()
			shooters_on_conveyor.append(shooter)
			return true
	push_warning("Shooter is not on the top of a column")
	return false

func update_conveyor(delta:float):
	for shooter in shooters_on_conveyor:
		#var step = shooter.current_step()
		#var position = Vector3(
			#step.grid_pos.x * grid_config.cell_size,
			#0,
			#step.grid_pos.y * grid_config.cell_size
		#)
		#
		#var view = shooter.view
		#view.global_position = view.global_position.linear_interpolate(target_pos, delta * conveyor_speed)
		
		if not shooter.has_shot_this_step:
			var target = shooter.find_target(grid)
			if target != Vector2i(-1,-1):
				grid.get_cell(target.x, target.y).hit()
			shooter.has_shot_this_step = true

#func check_full_rotation():
	#for shooter in shooters_on_conveyor.duplicate():
		#if shooter.path_index == 0:
			#shooters_on_conveyor.erase(shooter)
			#if shooters_on_bench.size()>=5:
				#push_error("GAMEOVER")
			#else:
				#shooters_in_reserve.append(shooter)
