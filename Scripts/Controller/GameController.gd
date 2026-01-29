extends Node
class_name GameController

@export var map_path: String = "res://Levels/1.txt"
@export var legend: GridLegend
@export var grid_view: GridView
@export var grid_config: GridConfig
@export var shooter_manager: ShooterManager
@export var color_controller: ColorController

func _ready():
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
	
	var loader = GridLoader.new()
	
	var grid = loader.load_from_file(map_path)
	if grid == null:
		push_error("GameController: failed to load grid from file")
		return
	
	grid_view.set_grid(grid, color_controller)
	
	var shooter_symbols = ["0","1","1","2","0"]
	var path = ConveyorPath.new().build(grid.width, grid.length)
	shooter_manager.spawn_shooters(shooter_symbols, path)
	
