extends MeshInstance3D

const MAX_BODIES := 16

func _process(_delta: float) -> void:
	var mat := get_active_material(0) as ShaderMaterial
	if mat == null:
		return
	var bodies := get_tree().get_nodes_in_group("gravity_sources")
	var positions := PackedVector3Array(); positions.resize(MAX_BODIES)
	var masses := PackedFloat32Array();   masses.resize(MAX_BODIES)
	var count := mini(bodies.size(), MAX_BODIES)
	for i in count:
		positions[i] = bodies[i].global_position
		masses[i] = bodies[i].mass
	mat.set_shader_parameter("body_count", count)
	mat.set_shader_parameter("body_positions", positions)
	mat.set_shader_parameter("body_masses", masses)
	
	if Engine.get_process_frames() % 60 == 0:
		print(count, " bodies, first mass = ", masses[0])
