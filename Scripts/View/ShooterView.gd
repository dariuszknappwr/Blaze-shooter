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
	_update_transform()

func setup(shooter_data: Shooter):
	shooter = shooter_data
	var color = color_controller.map_char_to_color(shooter.color_symbol)
	_apply_color(color)
	original_color = color
	

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

func _process(delta: float):
	if not shooter:
		return
	
	var step = shooter.current_step()
	target_position = Vector3(
		step.grid_pos.x * grid_config.cell_size,
		0,
		step.grid_pos.y * grid_config.cell_size
	)
	global_position = global_position.move_toward(target_position, delta * move_speed)
	
	look_at(global_position + Vector3(step.shoot_dir.x, 0, step.shoot_dir.y), Vector3.UP)
	
	if flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			_apply_color(original_color)
			flashing = false

func show_shot_effect():
	var flash_color = Color(1,0,0)
	_apply_color(flash_color)
	flashing = true
	flash_timer = flash_time

func initialize_position():
	target_position = global_position
	_update_transform()
