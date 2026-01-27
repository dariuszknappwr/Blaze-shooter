extends RefCounted

class_name Grid
var width : int
var length : int
var _values := []

func _init(w: int, l: int):
	self.width = w
	self.length = l
	_generate_empty_grid()


func _generate_empty_grid():
	_values.clear()
	for y in range(length):
		var row := []
		for x in range(width):
			row.append(Cell.new())
		_values.append(row)

func set_cell(x: int, y: int, cell: Cell) -> void:
	if not _in_bounds(x, y):
		push_error("Grid.set_cell: out of bounds (%d, %d)" % [x,y])
		return
	_values[y][x] = cell

func get_cell(x: int, y:int) -> Cell:
	if not _in_bounds(x, y):
		push_error("Grid.get_cell: out of bounds (%d, %d)" % [x,y])
		return
	return _values[y][x]

func _in_bounds(x: int, y: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < length
