extends Node

class_name GridView

@export var cell_view_scene : PackedScene
@export var grid_config: GridConfig
var width
var length
var grid : Grid
var gridNode : Node

func set_grid(new_grid: Grid, color_controller: ColorController):
	check_errors()
	grid = new_grid
	_generate_grid_view(color_controller)

func check_errors():
	if not cell_view_scene:
		push_error("GridView: Please fill cell view in Inspector!")
	if not (cell_view_scene is PackedScene):
		push_error("GridView: cell_view_scene is not of type PackedScene!")
	if not grid_config:
		push_error("GridView: Please fill grid_config in Inspector!")

func generate_grid_from_file(fileName: String, color_controller: ColorController):
	var path = "res://Levels/"+fileName
	var loader = GridLoader.new()
	grid = loader.load_from_file(path)
	_generate_grid_view(color_controller)

func _generate_grid_view(color_controller: ColorController):
	gridNode = Node3D.new()
	for y in range(grid.length):
		for x in range(grid.width):
			var cell = grid.get_cell(x, y)
			var cell_view = cell_view_scene.instantiate() as CellView
			cell_view.setup(cell, cell_view_scene, color_controller)
			var padding = grid_config.cell_size
			cell_view.position = Vector3(x * padding, 0, y * padding)
			gridNode.add_child(cell_view)
	
	add_child(gridNode)
