extends Node3D
class_name ShooterManager

@export var shooter_scene: PackedScene
@export var grid_config: GridConfig
@export var color_controller: ColorController
@export var rackView: RackView
@export var conveyorView: ConveyorPathView
@export var default_shooter_symbols: Array = ["0","1","1","2","0","1","2","0","0","1"]
@export var benchView: BenchView
@export var benchController: BenchController

var conveyor: ConveyorPath
var shooter_container_views: Dictionary = {}
var rack: Rack

func _process(delta: float):
	for shooter in conveyor.get_shooters_on_conveyor():
		var view = _get_view_for_shooter(shooter)
		var state = conveyor._get_shooter_state(shooter)
		var target_pos = conveyorView.get_conveyor_step_world_position_from_index(state.path_index)
		view.move_to(target_pos)

func spawn_shooters(shooter_symbols: Array, shooter_rack: Rack, conveyorPath_: ConveyorPath):
	rack = shooter_rack
	conveyor = conveyorPath_
	
	for i in range(shooter_symbols.size()):
		var color_symbol = shooter_symbols[i]
		var shooter = create_shooter(color_symbol, i, i)
		var view = create_shooter_view(shooter)
	
	_update_shooter_view()

func spawn_default_shooters(shooter_rack: Rack, conveyorPath_: ConveyorPath):
	spawn_shooters(default_shooter_symbols, shooter_rack, conveyorPath_)

func connect_signals(conveyorPath: ConveyorPath, rack_data: Rack):
	conveyor = conveyorPath
	conveyor.conveyor_full.connect(_on_conveyor_full)
	conveyor.shooter_completed_path.connect(_on_shooter_completed_path)
	rack_data.shooter_added_to_rack.connect(_on_shooter_added_to_rack)

func _on_conveyor_full():
	print("Conveyor is full! Game might need to handle this")

func _on_shooter_added_to_rack(shooter: Shooter, pos: Vector3):
	var view: Node3D = _get_view_for_shooter(shooter)
	if view == null:
		return
	
	var world_pos = rackView.get_shooter_world_position(shooter, rack)
	view.set_position(world_pos)

func _update_shooter_view():
	for shooter in shooter_container_views.keys():
		var view = _get_view_for_shooter(shooter)
		var world_pos = rackView.get_shooter_world_position(shooter, rack)
		view.set_position(world_pos)

func create_shooter(symbol: String, bullets: int, column: int):
	var shooter = Shooter.new(symbol, bullets)
	rack.add_shooter(shooter, column)
	return shooter

func create_shooter_view(shooter: Shooter):
	var view = ShooterViewFactory.create_shooter_view(shooter, shooter_scene, grid_config, color_controller, Callable(self, "_on_shooter_clicked"))
	add_child(view)
	shooter_container_views[shooter] = view
	return view

func get_current_step(shooter: Shooter) -> Step:
	return conveyor.get_step(shooter.path_index)

func _on_shooter_completed_path(shooter: Shooter):
	print("Shooter completed path")
	conveyor.remove_shooter_from_conveyor(shooter)
	var shooterView = _get_view_for_shooter(shooter)
	benchController.add_shooter_to_bench(shooter, shooterView)
	return

func _on_shooter_clicked(shooter):
	if not _move_shooter_from_rack_to_conveyor(shooter):
		return
	var view = _get_view_for_shooter(shooter)
	if view != null:
		view.move_to(conveyorView.get_conveyor_start_world_position())

func _get_view_for_shooter(shooter: Shooter) -> Node3D:
	return shooter_container_views.get(shooter)

func _move_shooter_from_rack_to_conveyor(shooter: Shooter) -> bool:
	if not rack.can_remove_shooter_from_top(shooter):
		return false
	
	if not conveyor.can_put_shooter_on_conveyor(shooter):
		return false
	
	rack.remove_shooter_from_top(shooter)
	conveyor.put_shooter_on_conveyor(shooter)
	return true
