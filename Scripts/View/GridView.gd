extends Node

class_name GridView

@export var width := 10
@export var length := 5
@export var padding := 1.2
@export var standard_cell_view : PackedScene
var grid : Grid
var gridNode : Node

func _ready() -> void:
	check_errors()
	grid = Grid.new(width, length)
	generate_random_grid()
	
func generate_standard_grid():
	gridNode = Node3D.new()
	gridNode.name = "Grid"
	
	for x in range(length):
		for z in range(width):
			var cell = grid.values[x][z]
			var cell_view = CellView.new()
			cell_view.setup(cell, standard_cell_view)
			cell_view.position = Vector3(x * padding, 0, z * padding)
			gridNode.add_child(cell_view)
		
	add_child(gridNode)

func generate_random_grid():
	gridNode = Node3D.new()
	gridNode.name = "Grid"
	
	for x in range(length):
		for z in range(width):
			var cell = grid.values[x][z]
			var random_color = Color(randf(), randf(), randf())
			cell.color = random_color
			var cell_view = CellView.new()
			cell_view.setup(cell, standard_cell_view)
			cell_view.position = Vector3(x * padding, 0, z * padding)
			gridNode.add_child(cell_view)
		
	add_child(gridNode)

func check_errors():
	if !standard_cell_view:
		push_error("GridView: Please fill cell view in Inspector!")
