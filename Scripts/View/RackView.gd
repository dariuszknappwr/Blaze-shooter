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
	
