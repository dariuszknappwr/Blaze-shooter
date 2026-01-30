extends Object
class_name ShooterTargetFinder

static func find_target_from_step(step, color_symbol: String, grid: Grid) -> Vector2i:
	var pos = step.grid.pos + step.shoot_dir
	var no_target_found = Vector2i(-1,-1)
	while grid.in_bounds(pos):
		var cell = grid.get_cell_safe(pos.x, pos.y)
		if not cell.is_empty():
			if cell.color_symbol != color_symbol:
				return no_target_found
			return pos
		pos += step.shoot_dir
	return no_target_found
