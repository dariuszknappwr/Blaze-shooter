extends Node3D
class_name ColorController

@export var legend: GridLegend

func map_char_to_color(character: String) -> Color:
	if not legend:
		push_error("ColorController: legend not assigned in Inspector!")
	if legend.has_symbol(character):
		return legend.get_color(character)
	push_error("Text files has characters that do not exist in Grid Legend")
	return Color.MAGENTA
