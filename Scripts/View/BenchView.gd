extends Node3D
class_name BenchView

@export var bench_starting_position : Vector3

func move_shooter_to_bench(shooterView: ShooterView, bench_slot: int):
	shooterView.move_to(bench_starting_position + Vector3.RIGHT * bench_slot)
	print("ShooterView moved")
