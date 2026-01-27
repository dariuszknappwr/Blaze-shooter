extends RefCounted
class_name GridLoader

func load_from_file(path: String) -> Grid:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open file: " + path + ". Check if file exists and is correct")
		return null
	
	var text  = file.get_as_text()
	file.close()
	
	var raw_lines = text.split("\n", true)
	var lines = _trim_empty_lines(raw_lines)
	
	var grid = Grid.new(lines[0].length(), lines.size())
	
	for y in range(lines.size()):
		var line = lines[y].strip_edges()
		
		for x in range(line.length()):
			var character = line[x]
			var cell = Cell.new()
			cell.color = _map_char_to_color(character)
			grid.set_cell(x,y,cell)
	
	return grid

func _map_char_to_color(character: String) -> Color:
	match character:
		"0":
			return Color(0.35, 0.525, 0.867, 1.0)
		"1":
			return Color.BLACK
		"2":
			return Color.RED
		_:
			return Color.MAGENTA

func _trim_empty_lines(lines: Array[String]) -> Array[String]:
	var result: Array[String] = []
	
	for line in lines:
		var trimmed = line.strip_edges()
		if trimmed.length() > 0:
			result.append(trimmed)
	
	return result
