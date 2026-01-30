extends Node
class_name GameController

@export var map_path: String = "res://Levels/1.txt"
@export var legend: GridLegend
@export var grid_view: GridView
@export var grid_config: GridConfig
@export var shooter_manager: ShooterManager
@export var color_controller: ColorController
var conveyor: ConveyorPath
var rack: Rack
var bench: Bench
@export var rackView: RackView

func _ready():
	check_errors()
	
	var loader = GridLoader.new()
	
	var grid = loader.load_from_file(map_path)
	if grid == null:
		push_error("GameController: failed to load grid from file")
		return
	
	grid_view.set_grid(grid, color_controller)
	rack = Rack.new()
	conveyor = ConveyorPath.new(rack)
	shooter_manager.connect_signals(conveyor, rack)
	bench = Bench.new()
	var pathArray = conveyor.get_steps(grid)
	
	rackView.setup(rack)
	
	var shooter_symbols = ["0","1","1","2","0","1","2","0","0","1"]
	shooter_manager.spawn_shooters(shooter_symbols, pathArray, rack, bench)
	for i in shooter_symbols.size():
		rackView.update_view(i)

func check_errors():
	if not legend:
		push_error("GameController: legend is not assigned!")
		return
	if not grid_view:
		push_error("GameController: grid_view is not assigned!")
		return
	if not grid_config:
		push_error("GameController: grid_config is not assigned")
		return
	if not shooter_manager:
		push_error("GameController: shooter_manager is not assigned")
		return
	if not color_controller:
		push_error("GameController: color_controller is not assigned")
		return
