extends Node3D
class_name ShooterManager

@export var shooter_scene: PackedScene
@export var grid_config: GridConfig

var shooters: Array[Shooter] = []
var shooter_views: Array[ShooterView] = []

func spawn_shooter(color_symbol: String,path: Array):
	var shooter = Shooter.new()
	shooter.color_symbol = color_symbol
	shooter.path = path
	shooters.append(shooter)
	
	var view = shooter_scene.instantiate() as ShooterView
	view.grid_config = grid_config
	view.setup(shooter)
	
	shooter_views.append(view)
	add_child(view)
