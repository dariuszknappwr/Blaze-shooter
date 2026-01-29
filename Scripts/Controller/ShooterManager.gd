extends Node3D
class_name ShooterManager

@export var shooter_scene: PackedScene
@export var grid_config: GridConfig
@export var max_conveyor_shooters := 5
@export var conveyor_speed := 2.0
@export var color_controller: ColorController
@export var rack_columns := 4

var shooters: Array[Shooter] = []
var shooter_views: Array[ShooterView] = []
var rack: Rack
var bench
var conveyor_path_obj: ConveyorPath
var conveyor_path: Array

func spawn_shooters(shooter_symbols: Array, path: Array, shooter_rack: Rack, bench_data: Bench):
	conveyor_path = path
	rack = shooter_rack
	bench = bench_data
	
	for i in range(shooter_symbols.size()):
		var color_symbol = shooter_symbols[i]
		var shooter = create_shooter(color_symbol)
		var view = create_shooter_view(shooter)
		
		
		var col = i % rack_columns
		var row = i / rack_columns
		var rack_pos = Vector3(
			col * grid_config.cell_size,
			0,
			row * grid_config.cell_size
		)
		rack.add_shooter(shooter, col)
		
		view.position = rack_pos
		view.target_position = rack_pos

func connect_conveyor_signals(conveyor: ConveyorPath):
	conveyor_path_obj = conveyor
	conveyor.shooter_added_to_conveyor.connect(_on_shooter_added_to_conveyor)
	conveyor.conveyor_full.connect(_on_conveyor_full)
	conveyor.shooter_completed_rotation.connect(_on_shooter_completed_rotation)

func _on_shooter_added_to_conveyor(shooter: Shooter):
	print("Shooter added to conveyor: ", shooter.color_symbol)
	# ShooterManager can now invoke Bench methods if needed

func _on_conveyor_full():
	print("Conveyor is full! Game might need to handle this")


#func update_conveyor(delta:float):
	#for shooter in shooters_on_conveyor:
		#var step = shooter.current_step()
		#var target_pos = Vector3(
			#step.grid_pos.x * grid_config.cell_size,
			#0,
			#step.grid_pos.y * grid_config.cell_size
		#)
		#
		#var view = shooter.view
		#view.gloval_position = view.gloval_position.linear_interpolate(target_pos, delta * conveyor_speed)
		#
		#if not shooter.has_shot_this_step:
			#var target = shooter.find_target(grid_config.grid)
			#if target != Vector2i(-1,-1):
				#grid_config.grid.get_cell(target.x, target.y).hit()
			#shooter.has_shot_this_step = true

#func check_full_rotation():
	#for shooter in shooters_on_conveyor.duplicate():
		#if shooter.path_index == 0:
			#shooters_on_conveyor.erase(shooter)
			#if shooters_in_reserve.size()>=5:
				#push_error("GAMEOVER")
			#else:
				#shooters_in_reserve.append(shooter)

func create_shooter(symbol):
	var shooter = Shooter.new(symbol, 10, conveyor_path)
	shooters.append(shooter)
	return shooter

func create_shooter_view(shooter: Shooter):
	var view = shooter_scene.instantiate() as ShooterView
	view.grid_config = grid_config
	view.color_controller = color_controller
	view.setup(shooter)
	add_child(view)
	view.initialize_position()
	shooter_views.append(view)
	return view

func get_current_step(shooter: Shooter) -> ConveyorPath.Step:
	return conveyor_path[shooter.path_index]

func _on_shooter_completed_rotation(shooter: Shooter):
	bench.add_shooter(shooter)
