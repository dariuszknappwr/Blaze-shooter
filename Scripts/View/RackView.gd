extends Node3D
class_name RackView

@export var slot_scene: PackedScene
var rack: Rack

func setup(rack_data: Rack):
	rack = rack_data
	for i in range(rack.slots.size()):
		var slot = slot_scene.instantiate()
		var col = rack.get_slot_position(i).x
		var row = rack.get_slot_position(i).z
		slot.position = Vector3(col,0,row)
		add_child(slot)

func get_rack_starting_position():
	return position
