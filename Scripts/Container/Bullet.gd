extends CharacterBody3D

class_name Bullet

var color_symbol: String
var speed: float = 30.0
var direction: Vector3
var grid_config: GridConfig
var on_hit_callback: Callable
var max_distance: float = 100.0
var traveled_distance: float = 0.0

func _ready() -> void:
	pass

func setup(symbol: String, start_pos: Vector3, dir: Vector3, config: GridConfig, callback: Callable) -> void:
	color_symbol = symbol
	position = start_pos
	direction = dir.normalized()
	grid_config = config
	on_hit_callback = callback

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var prev_pos = position
	move_and_slide()
	traveled_distance += position.distance_to(prev_pos)
	
	if traveled_distance > max_distance:
		queue_free()

func check_grid_collision(grid: Grid) -> Vector2i:
	var cell_pos = Vector2i(
		int(round(position.x / grid_config.cell_size)),
		int(round(position.z / grid_config.cell_size))
	)
	
	if grid.in_bounds(cell_pos):
		var cell = grid.get_cell(cell_pos.x, cell_pos.y)
		if not cell.is_empty():
			return cell_pos
	
	return Vector2i(-1, -1)
