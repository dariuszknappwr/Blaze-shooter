extends RefCounted
class_name Cell

var length := 1
var width := 1
var color_symbol : String
var hit_points := 1


func is_empty():
	return hit_points <= 0

func hit():
	hit_points = hit_points - 1
