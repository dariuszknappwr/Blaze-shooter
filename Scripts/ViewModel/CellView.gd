extends Node3D

class_name CellView

var cell: Cell
var cellView: PackedScene

func setup(cell_data: Cell, cell_view: PackedScene, color_controller: ColorController):
	cell = cell_data
	cellView = cell_view
	
	if cellView:
		var cellNode = cellView.instantiate()
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = color_controller.map_char_to_color(cell.color_symbol)
		cellNode.material_override = mat
		add_child(cellNode)
