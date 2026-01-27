extends Node

class_name GridView

var width := 10
var length := 5
@export var padding := 1.2
@export var cell_view_scene : PackedScene
var grid : Grid
var gridNode : Node

func _ready() -> void:
	check_errors()
	grid = Grid.new(width, length)
	generate_grid_from_file("1.txt")

func generate_random_grid():
	for x in range(length):
		for z in range(width):
			var cell = grid.values[x][z]
			var random_color = Color(randf(), randf(), randf())
			cell.color = random_color
			var cell_view = CellView.new()
			cell_view.setup(cell, cell_view_scene)
			cell_view.position = Vector3(x * padding, 0, z * padding)
			gridNode.add_child(cell_view)
		
	add_child(gridNode)

func check_errors():
	if not cell_view_scene:
		push_error("GridView: Please fill cell view in Inspector!")
	if not (cell_view_scene is PackedScene):
		push_error("GridView: cell_view_scene is not of type PackedScene!")

func generate_grid_from_file(fileName: String):
	var path = "res://Levels/"+fileName
	var loader = GridLoader.new()
	grid = loader.load_from_file(path)
	_generate_grid_view()

func _generate_grid_view():
	gridNode = Node3D.new()
	for y in range(grid.length):
		for x in range(grid.width):
			var cell = grid.get_cell(x, y)
			var cell_view = cell_view_scene.instantiate() as CellView
			cell_view.setup(cell, cell_view_scene)
			cell_view.position = Vector3(x * padding, 0, y * padding)
			gridNode.add_child(cell_view)
	
	add_child(gridNode)
