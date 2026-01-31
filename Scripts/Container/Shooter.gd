extends RefCounted

class_name Shooter

var number_of_bullets: int
var color_symbol : String

func _init(symbol: String, bullets: int):
	color_symbol = symbol
	number_of_bullets = bullets
