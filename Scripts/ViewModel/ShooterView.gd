extends Node3D
class_name ShooterView

@export var grid_config: GridConfig
@export var legend: GridLegend
var shooter: Shooter

func _ready() -> void:
	if not grid_config:
		push_error("ShooterView: Please fill grid_config in Inspector!")
	_update_transform()

func setup(shooter_data: Shooter):
	shooter = shooter_data
	var color = legend.get_color(shooter.color_symbol)
	_apply_color(color)
	

func _update_transform():
	var step = shooter.current_step()
	position = Vector3(
		step.grid_pos.x * grid_config.cell_size,
		0,
		step.grid_pos.y * grid_config.cell_size
	)

	look_at(
		position + Vector3(step.shoot_dir.x, 0, step.shoot_dir.y),
		Vector3.UP
	)

func _apply_color(color: Color):
	for child in get_children():
		if child is MeshInstance3D:
			var mat : StandardMaterial3D = child.material_override as StandardMaterial3D
			if mat == null:
				mat = StandardMaterial3D.new()
				child.material_override = mat
			mat.albedo_color = color
