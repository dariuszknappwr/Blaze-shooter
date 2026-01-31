extends Node3D
class_name ShooterView

@export var grid_config: GridConfig
@export var color_controller: ColorController

var shooter: Shooter
var move_speed := 5.0
var target_position: Vector3
var original_color: Color
signal clicked(shooter: Shooter)

func _ready() -> void:
	if not grid_config:
		push_error("ShooterView: Please fill grid_config in Inspector!")
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	area.add_child(collision)
	add_child(area)
	area.input_event.connect(_on_area_clicked)
	target_position = global_transform.origin

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

func _on_area_clicked(camera, event, pos, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(shooter)

func move_to(target: Vector3):
	target_position = target

func _process(delta: float) -> void:
	if target_position != null:
		global_transform.origin = global_transform.origin.lerp(target_position, move_speed * delta)
