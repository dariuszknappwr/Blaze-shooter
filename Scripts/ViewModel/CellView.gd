extends Node3D

class_name CellView

var cell: Cell
var cellView: PackedScene

func setup(cell_data: Cell, cell_view: PackedScene):
	cell = cell_data
	cellView = cell_view
	
	if cellView:
		var cellNode = cellView.instantiate()
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = cell.color
		cellNode.material_override = mat
		add_child(cellNode)
