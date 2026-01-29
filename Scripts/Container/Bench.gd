extends RefCounted
class_name Bench

var max_size := 5
var slots : Array = []

func add_shooter(shooter: Shooter):
	if slots.size() >= max_size:
		push_error("Game Over!")
		return
	slots.append(shooter)

#func pop_shooter(shooter: Shooter):
	#slots.pop
#
#func get_bench_column(shooter: Shooter):
	#slots.get(shooter)
