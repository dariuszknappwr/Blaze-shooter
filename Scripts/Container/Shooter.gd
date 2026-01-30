extends RefCounted

class_name Shooter

var number_of_bullets: int
var color_symbol : String
var path_index := 0
var path : Array

func _init(symbol: String, bullets: int, path_array: Array):
	color_symbol = symbol
	number_of_bullets = bullets
	path = path_array

func advance():
	path_index = (path_index + 1) % path.size()

func current_step():
	return path[path_index]

func find_target(grid: Grid) -> Vector2i:
	var step = current_step()
	return ShooterTargetFinder.find_target_from_step(step, color_symbol, grid)
