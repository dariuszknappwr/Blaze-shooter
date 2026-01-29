extends RefCounted
class_name Rack

var shooters_on_rack: Array = []
var number_of_columns := 4

func _init():
	shooters_on_rack.clear()
	shooters_on_rack.resize(number_of_columns)
	
	for col in range(number_of_columns):
		shooters_on_rack[col] = []

func add_shooter(shooter: Shooter, column: int):
	shooters_on_rack[column].append(shooter)
