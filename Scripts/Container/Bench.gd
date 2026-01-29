extends RefCounted
class_name Bench

var max_size := 5
var slots : Array = []

func add_shooter(shooter: Shooter):
	if slots.size() >= max_size:
		push_error("Game Over!")
		return
	slots.append(shooter)

func pop_shooter(shooter: Shooter) -> bool:
	var index = slots.find(shooter)
	if index != -1:
		slots.remove_at(index)
		return true
	return false

func get_shooter_index(shooter: Shooter) -> int:
	return slots.find(shooter)

func get_bench_column(shooter: Shooter) -> int:
	return slots.find(shooter)
