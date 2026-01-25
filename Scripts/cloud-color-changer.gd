extends Node3D

@onready var mesh = self

func set_cloud_color(new_color: Color):
	print(mesh)
	var material = mesh.get_active_material(0)
	material = material.duplicate()
	mesh.set_surface_override_material(0,material)
	
	material.albedo_color = new_color
	
func _ready():
	set_cloud_color(Color(randfn(0.0,1.0),randfn(0.0,1.0),randfn(0.0,1.0)))
