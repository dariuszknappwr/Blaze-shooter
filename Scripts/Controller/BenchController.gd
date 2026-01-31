extends Node3D
class_name BenchController

@export var benchView: BenchView

func move_shooter_to_bench(shooterView: ShooterView):
	benchView.move_shooter_to_bench(shooterView)
