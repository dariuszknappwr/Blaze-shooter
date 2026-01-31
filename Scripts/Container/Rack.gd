extends RefCounted
class_name Rack

var slots: Array = []
var number_of_columns := 4
signal shooter_added_to_rack(shooter: Shooter, position: Vector3)

func _init():
	slots.clear()
	slots.resize(number_of_columns)
	
	for col in range(number_of_columns):
		slots[col] = []

func add_shooter(shooter: Shooter, column: int):
	slots[column%number_of_columns].append(shooter)
	var position = get_slot_position(slots[column%number_of_columns].size())
	shooter_added_to_rack.emit(shooter, position)

func get_shooter_position(shooter: Shooter) -> Vector2i:
	for col in range(number_of_columns):
		for row in range(slots[col].size()):
			if slots[col][row] == shooter:
				return Vector2i(col,row)
	return Vector2i(-1,-1)

func get_slot_position(i: int) -> Vector3:
	var col = i % number_of_columns
	var row = i / number_of_columns
	return Vector3(col, 0, row)

func is_shooter_on_top(shooter: Shooter) -> bool:
	for col in slots:
		if col.size() > 0 and col[col.size() - 1] == shooter:
			return true
	return false

func can_remove_shooter_from_top(shooter: Shooter) -> bool:
	return _find_column_with_shooter_on_top(shooter) != null

func remove_shooter_from_top(shooter: Shooter):
	var col = _find_column_with_shooter_on_top(shooter)
	col.pop_back()

func _find_column_with_shooter_on_top(shooter: Shooter):
	for col in slots:
		if col.size() > 0 and col[col.size() - 1] == shooter:
			return col
