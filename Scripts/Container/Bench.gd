extends RefCounted
class_name Bench

var max_size := 5
var slots : Array = []
signal gameOver

func add_shooter(shooter: Shooter):
	if is_full():
		print("Game Over!")
		gameOver.emit()
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

func is_full() -> bool:
	return get_size() >= max_size

func get_size() -> int:
	return slots.size()
