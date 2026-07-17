shader_type spatial;
render_mode cull_disabled;
uniform int body_count;
uniform vec3 body_positions[16];
uniform float body_masses[16];

uniform float well_strength = 0.5;
uniform float well_softening = 1.5;
uniform float max_depth = 150.0;
uniform vec3 sheet_color : source_color = vec3(0.01, 0.01, 0.02);  // near-black background
uniform vec3 line_color  : source_color = vec3(0.15, 0.18, 0.28);  // subtle lines, everywhere
uniform vec3 glow_color  : source_color = vec3(0.3, 0.6, 1.0);     // glow tint, wells only
uniform float glow_strength = 5.0;
uniform float well_range = 8.0;   
uniform float line_sharpness = 0.02;
varying vec3 world_pos;
varying float well_amount;

void vertex() {
	float depth = 0.0;
	for(int i =0;i<body_count;i++){
		float d = distance(VERTEX.xz, body_positions[i].xz);
		depth -= well_strength*body_masses[i]/(d+well_softening);
	}
	float dip = max(depth, -max_depth);
	VERTEX.y += dip;
	well_amount = clamp(-dip/well_range, 0.0, 1.0);
	world_pos = VERTEX;
}

void fragment() {
	vec2 g  = abs(fract(world_pos.xz) - 0.5);
	float line = 1.0 - smoothstep(0.0, line_sharpness, min(g.x, g.y));
	vec3 base = mix(sheet_color, line_color, line);
	vec3 glow = glow_color * line * line_color * well_amount;
	ALBEDO = base + glow * 2.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
