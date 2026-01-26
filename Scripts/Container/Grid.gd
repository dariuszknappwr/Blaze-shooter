extends RefCounted

class_name Grid
var width : int
var length : int
var values := []

func _init(w: int, l: int):
	self.width = w
	self.length = l
	generate_grid()


func generate_grid() -> Array:
	values.clear()
	for x in range(length):
		var row := []
		for z in range(width):
			row.append(Cell.new())
		values.append(row)
	return values
