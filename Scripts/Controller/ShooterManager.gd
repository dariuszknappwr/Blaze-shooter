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

var shooter_rack: Array = []

var shooters_on_conveyor: Array[Shooter] = []
var shooters_in_reserve: Array[Shooter] = []

func spawn_shooters(shooter_symbols: Array,path: Array):
	shooter_rack.clear()
	shooter_rack.resize(rack_columns)
	
	for col in range(rack_columns):
		shooter_rack[col] = []
	
	for i in range(shooter_symbols.size()):
		var color_symbol = shooter_symbols[i]
		
		var shooter = Shooter.new()
		shooter.color_symbol = color_symbol
		shooter.path = path
		shooters.append(shooter)
	
		var view = shooter_scene.instantiate() as ShooterView
		view.grid_config = grid_config
		view.color_controller = color_controller
		view.setup(shooter)
		add_child(view)
		view.initialize_position()
		
		shooter_views.append(view)
		
		var col = i % rack_columns
		var row = i / rack_columns
		shooter_rack[col].append(shooter)
		
		view.position = Vector3(
			col * grid_config.cell_size,
			0,
			row * grid_config.cell_size)

func try_place_shooter_on_conveyor(shooter: Shooter) -> bool:
	for col in shooter_rack:
		if col.size() > 0 and col[col.size() -1] == shooter:
			if shooters_on_conveyor.size() >= max_conveyor_shooters:
				push_warning("Conveyor full")
				return false
			
			col.pop_back()
			shooters_on_conveyor.append(shooters)
			return true
	push_warning("Shooter nie jest na szczycie kolumny")
	return false

func update_conveyor(delta:float):
	for shooter in shooters_on_conveyor:
		var step = shooter.current_step()
		var target_pos = Vector3(
			step.grid_pos.x * grid_config.cell_size,
			0,
			step.grid_pos.y * grid_config.cell_size
		)
		
		var view = shooter.view
		view.gloval_position = view.gloval_position.linear_interpolate(target_pos, delta * conveyor_speed)
		
		if not shooter.has_shot_this_step:
			var target = shooter.find_target(grid_config.grid)
			if target != Vector2i(-1,-1):
				grid_config.grid.get_cell(target.x, target.y).hit()
			shooter.has_shot_this_step = true

func check_full_rotation():
	for shooter in shooters_on_conveyor.duplicate():
		if shooter.path_index == 0:
			shooters_on_conveyor.erase(shooter)
			if shooters_in_reserve.size()>=5:
				push_error("GAMEOVER")
			else:
				shooters_in_reserve.append(shooter)
