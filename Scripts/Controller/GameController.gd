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
	if not GameControllerValidator.validate(self):
		return
	
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
	
	shooter_manager.spawn_default_shooters(pathArray, rack, bench, conveyor)
