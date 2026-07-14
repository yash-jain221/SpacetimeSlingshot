shader_type spatial;
render_mode cull_disabled;
uniform int body_count;
uniform vec3 body_positions[16];
uniform float body_masses[16];

uniform float well_strength = 0.5;
uniform float well_softening = 1.5;
uniform float max_depth = 150.0;
uniform vec3 grid_color : source_color  = vec3(0.2, 0.5, 1.0);
uniform float line_sharpness = 0.04;
varying vec3 world_pos;



void vertex() {
	float depth = 0.0;
	for(int i =0;i<body_count;i++){
		float d = distance(VERTEX.xz, body_positions[i].xz);
		depth -= well_strength*body_masses[i]/(d+well_softening);
	}
	VERTEX.y += max(depth, -max_depth);
	world_pos = VERTEX;
}

void fragment() {
	vec2 g  = abs(fract(world_pos.xz) - 0.5);
	float line = 1.0 - smoothstep(0.0, line_sharpness, min(g.x, g.y));
	ALBEDO = vec3(0.02, 0.02, 0.05);
	EMISSION = grid_color * line * 2.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
