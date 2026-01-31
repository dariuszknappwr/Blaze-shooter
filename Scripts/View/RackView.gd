extends Node3D
class_name RackView

@export var slot_scene: PackedScene
@export var grid_config: GridConfig
var rack: Rack

func setup(rack_data: Rack):
	rack = rack_data
	for i in range(rack.slots.size()):
		var slot = slot_scene.instantiate()
		add_child(slot)

func update_view(i: int):
	var slotView = slot_scene.instantiate()
	add_child(slotView)
	var pos = rack.get_slot_position(i) * grid_config.cell_size
	slotView.set_position(pos)

func get_rack_starting_position():
	return position
	
func get_shooter_world_position(shooter: Shooter, rack: Rack) -> Vector3:
	var pos2D = rack.get_shooter_position(shooter)
	var pos3D = Vector3(pos2D.x, 0, pos2D.y)
	var root_pos = get_rack_starting_position()
	return root_pos + pos3D * grid_config.cell_size
