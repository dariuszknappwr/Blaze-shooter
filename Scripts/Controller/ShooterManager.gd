extends Node3D
class_name ShooterManager

@export var shooter_scene: PackedScene
@export var grid_config: GridConfig
@export var max_conveyor_shooters := 5
@export var conveyor_speed := 2.0
@export var color_controller: ColorController
@export var rackView: RackView
@export var default_shooter_symbols: Array = ["0","1","1","2","0","1","2","0","0","1"]

var conveyor: ConveyorPath
var shooter_container_views: Dictionary = {}
var rack: Rack
var bench
var path: Array
signal shooter_sent_to_bench(shooter: Shooter)


func spawn_shooters(shooter_symbols: Array, path_: Array, shooter_rack: Rack, bench_data: Bench, conveyorPath_: ConveyorPath):
	path = path_
	rack = shooter_rack
	bench = bench_data
	conveyor = conveyorPath_
	
	for i in range(shooter_symbols.size()):
		var color_symbol = shooter_symbols[i]
		var shooter = create_shooter(color_symbol, i, i)
		var view = create_shooter_view(shooter)
	
	_update_shooter_view()
	update_rack_view()

func spawn_default_shooters(path, shooter_rack: Rack, bench_data: Bench, conveyorPath_: ConveyorPath):
	spawn_shooters(default_shooter_symbols, path, shooter_rack, bench_data, conveyorPath_)

func connect_signals(conveyorPath: ConveyorPath, rack_data: Rack):
	conveyor = conveyorPath
	conveyor.shooter_added_to_conveyor.connect(_on_shooter_added_to_conveyor)
	conveyor.conveyor_full.connect(_on_conveyor_full)
	conveyor.shooter_completed_rotation.connect(_on_shooter_completed_rotation)
	rack_data.shooter_added_to_rack.connect(_on_shooter_added_to_rack)

func _on_shooter_added_to_conveyor(shooter: Shooter):
	print("Shooter added to conveyor: ", shooter.color_symbol)
	# ShooterManager can now invoke Bench methods if needed

func _on_conveyor_full():
	print("Conveyor is full! Game might need to handle this")

func _on_shooter_added_to_rack(shooter: Shooter, pos: Vector3):
	var view = shooter_container_views.get(shooter)
	#shooter.set_position(pos)

func _update_shooter_view():
	for shooter in shooter_container_views.keys():
		var view = shooter_container_views[shooter]
		var pos2D = rack.get_shooter_position(shooter)
		var pos3D = Vector3(pos2D.x, 0, pos2D.y)
		var rootPos = rackView.get_rack_starting_position()
		view.set_position(rootPos + pos3D * grid_config.cell_size)

func create_shooter(symbol: String, bullets: int, column: int):
	var shooter = Shooter.new(symbol, bullets, path)
	rack.add_shooter(shooter, column)
	return shooter

func create_shooter_view(shooter: Shooter):
	var view = ShooterViewFactory.create_shooter_view(shooter, shooter_scene, grid_config, color_controller, Callable(self, "_on_shooter_clicked"))
	add_child(view)
	shooter_container_views[shooter] = view
	return view

func get_current_step(shooter: Shooter) -> ConveyorPath.Step:
	return conveyor.get_step(shooter.path_index)

func _on_shooter_completed_rotation(shooter: Shooter):
	shooter_sent_to_bench.emit(shooter)

func _on_shooter_clicked(shooter):
	print(shooter.color_symbol)
	conveyor.try_put_shooter_on_conveyor(shooter)

func update_rack_view() -> void:
	for i in range(shooter_container_views.keys().size()):
		rackView.update_view(i)
