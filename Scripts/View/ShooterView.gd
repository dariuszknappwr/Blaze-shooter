extends Node3D
class_name ShooterView

@export var grid_config: GridConfig
@export var color_controller: ColorController

var shooter: Shooter
var move_speed := 5.0
var target_position: Vector3

var flash_time := 0.2
var flashing := false
var flash_timer := 0.0
var original_color: Color

func _ready() -> void:
	if not grid_config:
		push_error("ShooterView: Please fill grid_config in Inspector!")


func setup(shooter_data: Shooter):
	shooter = shooter_data
	var color = color_controller.map_char_to_color(shooter.color_symbol)
	_apply_color(color)
	original_color = color
	



func _apply_color(color: Color):
	for child in get_children():
		if child is MeshInstance3D:
			var mat : StandardMaterial3D = child.material_override as StandardMaterial3D
			if mat == null:
				mat = StandardMaterial3D.new()
				child.material_override = mat
			mat.albedo_color = color
