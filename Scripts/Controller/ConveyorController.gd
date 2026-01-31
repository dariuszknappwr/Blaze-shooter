extends Node3D
class_name ConveyorController

@export var shooterView: ShooterView
var conveyor: ConveyorPath
func setup(conveyor_data: ConveyorPath):
	conveyor = conveyor_data

func _process(delta: float):
	conveyor.update_conveyor(delta)
