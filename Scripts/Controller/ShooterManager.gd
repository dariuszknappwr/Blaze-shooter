extends Node3D
class_name ShooterManager

@export var shooter_scene: PackedScene
@export var grid_config: GridConfig
@export var max_conveyor_shooters := 5
@export var conveyor_speed := 2.0
@export var color_controller: ColorController
@export var rackView: RackView
var conveyor: ConveyorPath

var shooters: Array[Shooter] = []
var shooter_views: Array[ShooterView] = []
var shooter_container_views: Dictionary = {}
var rack: Rack
var bench
var conveyor_path_obj: ConveyorPath
var path: Array
var conveyorPath: ConveyorPath

func _ready():
	_update_shooter_view()
		

func spawn_shooters(shooter_symbols: Array, path_: Array, shooter_rack: Rack, bench_data: Bench, conveyorPath_: ConveyorPath):
	path = path_
	rack = shooter_rack
	bench = bench_data
	conveyorPath = conveyorPath_
	
	for i in range(shooter_symbols.size()):
		var color_symbol = shooter_symbols[i]
		var shooter = create_shooter(color_symbol, i, i)
		var view = create_shooter_view(shooter)

func connect_signals(conveyor: ConveyorPath, rack_data: Rack):
	conveyor_path_obj = conveyor
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
	shooters.append(shooter)
	return shooter

func create_shooter_view(shooter: Shooter):
	var view = shooter_scene.instantiate() as ShooterView
	view.grid_config = grid_config
	view.color_controller = color_controller
	view.setup(shooter)
	view.clicked.connect(_on_shooter_clicked)
	add_child(view)
	shooter_views.append(view)
	shooter_container_views[shooter] = view
	return view

func get_current_step(shooter: Shooter) -> ConveyorPath.Step:
	return path[shooter.path_index]

func _on_shooter_completed_rotation(shooter: Shooter):
	bench.add_shooter(shooter)

func _on_shooter_clicked(shooter):
	print(shooter.color_symbol)
	conveyorPath.try_put_shooter_on_conveyor(shooter)
