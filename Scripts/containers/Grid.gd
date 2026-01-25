extends Node

class_name Grid
@export var width := 20
@export var length := 10
var grid := []


func generate_grid():
	for x in range(length):
		var row := []
		for z in range(width):
			row.append(Cell.new())
		grid.append(row)
