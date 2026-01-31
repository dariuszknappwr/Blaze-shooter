extends RefCounted
class_name ConveyorShooterState

var shooter: Shooter
var path_index: int = -1 #before first cell
var has_shot_this_step: bool
var time_since_last_step := 0.0
var step_interval := 0.1 #time to conveyor field in seconds

func _init(shooter_data: Shooter):
	shooter = shooter_data

func get_shooter():
	return shooter

func get_next_step_index():
	return path_index + 1

func advance():
	path_index += 1
