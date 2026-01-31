extends Node3D
class_name ConveyorPathView

@export var padding_between_grid: int = 1
@export var grid_config: GridConfig
var conveyor_path: ConveyorPath
var grid: Grid


func setup(path: ConveyorPath, grid_data: Grid):
	conveyor_path = path
	grid = grid_data

func get_conveyor_start_world_position():
	var grid_size = grid.get_grid_size()
	var array_offset = 1 #grid of size 6 withh return 5 (from 0 to 5) so we add 1
	var grid_length = grid_size.y + array_offset
	var grid_length_with_padding = grid_length * grid_config.cell_size
	var last_cell_in_grid = Vector2(0,grid_length_with_padding)
	var down_left_corner = Vector2(-1,-1) * grid_config.cell_size
	var starting_position = last_cell_in_grid + down_left_corner * padding_between_grid
	return Vector3(starting_position.x, 0, starting_position.y)
