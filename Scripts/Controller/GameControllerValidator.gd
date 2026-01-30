extends Object
class_name GameControllerValidator

static func validate(game_controller) -> bool:
	if not game_controller.legend:
		push_error("GameController: legend is not assigned!")
		return false
	if not game_controller.grid_view:
		push_error("GameController: grid_view is not assigned!")
		return false
	if not game_controller.grid_config:
		push_error("GameController: grid_config is not assigned")
		return false
	if not game_controller.shooter_manager:
		push_error("GameController: shooter_manager is not assigned")
		return false
	if not game_controller.color_controller:
		push_error("GameController: color_controller is not assigned")
		return false
	return true
