extends Object
class_name ShooterViewFactory

static func create_shooter_view(
	shooter: Shooter,
	scene: PackedScene,
	grid_config: GridConfig,
	color_controller: ColorController,
	clicked_ref: Callable
	) -> ShooterView:
		var view = scene.instantiate() as ShooterView
		view.grid_config = grid_config
		view.color_controller = color_controller
		view.setup(shooter)
		view.clicked.connect(clicked_ref)
		return view
