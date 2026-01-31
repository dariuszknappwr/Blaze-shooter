extends Node3D
class_name BenchController

@export var benchView: BenchView
var bench: Bench

func setup(bench_data: Bench):
	bench = bench_data

func add_shooter_to_bench(shooter:Shooter, shooterView: ShooterView):
	bench.add_shooter(shooter)
	var bench_slot = bench.get_size()
	benchView.move_shooter_to_bench(shooterView, bench_slot)

func can_add_shooter():
	return !bench.is_full()
