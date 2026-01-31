extends RefCounted

class_name Grid
var _width : int
var _length : int
var _values := []

func _init(w: int, l: int):
	_width = w
	_length = l
	_generate_empty_grid()


func _generate_empty_grid():
	_values.clear()
	for y in range(_length):
		var row := []
		for x in range(_width):
			row.append(Cell.new())
		_values.append(row)

func set_cell(x: int, y: int, cell: Cell) -> void:
	if not in_bounds(Vector2i(x, y)):
		push_error("Grid.set_cell: out of bounds (%d, %d)" % [x,y])
		return
	_values[y][x] = cell

func get_cell(x: int, y:int) -> Cell:
	if not in_bounds(Vector2i(x, y)):
		push_error("Grid.get_cell: out of bounds (%d, %d)" % [x,y])
		return
	return _values[y][x]

func in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < _width and pos.y >= 0 and pos.y < _length

func get_cell_safe(x: int, y: int) -> Cell:
	if not in_bounds(Vector2i(x,y)):
		return null
	return _values[y][x]

func get_grid_size() -> Vector2i:
	return Vector2i(_width,_length)
