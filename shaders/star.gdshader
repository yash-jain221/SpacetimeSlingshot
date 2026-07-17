shader_type spatial;

uniform sampler3D noise_tex;
uniform float noise_scale = 2.0;
uniform float churn_speed = 0.05;
uniform vec3 core_color = vec3(1.0, 0.95, 0.6);
uniform vec3 edge_color = vec3(1.0, 0.45, 0.1);
uniform float brightness = 4.0;

varying vec3 local_pos;

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	float n = texture(noise_tex, local_pos * noise_scale + vec3(TIME * churn_speed)).r;
	vec3 col = mix(edge_color, core_color, n);
	ALBEDO = vec3(0.0);
	EMISSION = col * brightness;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
