extends Node3D
class_name ConveyorPathView

var conveyor_path: ConveyorPath
var grid: Grid

func setup(path: ConveyorPath, grid: Grid):
	conveyor_path = path

func get_conveyor_start_world_position():
	return position
