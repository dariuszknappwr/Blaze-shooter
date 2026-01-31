extends Node3D
class_name BenchView

@export var bench_starting_position : Vector3

func move_shooter_to_bench(shooterView: ShooterView):
	shooterView.move_to(bench_starting_position)
	print("ShooterView moved")
