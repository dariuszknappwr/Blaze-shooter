extends RefCounted

class_name Shooter

var number_of_bullets: int
var color_symbol : String
var path: Array
var path_index := 0

func advance():
	path_index = (path_index + 1) % path.size()

func current_step():
	return path[path_index]

func find_target(grid: Grid) -> Vector2i:
	var step = current_step()
	var pos = step.grid_pos + step.shoot_dir
	
	var no_target_found := Vector2(-1,-1)
	
	while grid.in_bounds(pos):
		var cell = grid.get_cell(pos.x, pos.y)
		if not cell.is_empty():
			if cell.color_symbol != color_symbol:
				return no_target_found
			return pos
		pos += step.shoot_dir
	
	return no_target_found
