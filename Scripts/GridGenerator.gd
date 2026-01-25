extends Node

@export var grid_size := 20
@export var padding := 2
var grid: Grid 

func _ready() -> void:
	generate_grid()
	
func generate_grid():
	for x in range(grid_size):
		for z in range(grid_size):
			Grid[x,z]
			cell.position = Vector3(x, 0, z)
