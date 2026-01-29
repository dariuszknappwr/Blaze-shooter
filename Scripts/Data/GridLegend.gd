extends Resource

class_name GridLegend

@export var char_to_color: Dictionary = {}

func get_color(character: String) -> Color:
	return char_to_color.get(character)

func get_available_colors() -> Array[Color]:
	return char_to_color.values()

func has_symbol(character: String):
	return char_to_color.has(character)
