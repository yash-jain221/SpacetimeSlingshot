shader_type spatial;

uniform sampler3D noise_tex : repeat_enable;
uniform float  noise_scale = 1.5;
uniform vec3 seed_offset = vec3(0.0);
uniform float sea_level = 0.5;

uniform vec3 deep_water    : source_color = vec3(0.02, 0.10, 0.35);
uniform vec3 shallow_water : source_color = vec3(0.10, 0.40, 0.70);
uniform vec3 sand          : source_color = vec3(0.80, 0.75, 0.50);
uniform vec3 grass         : source_color = vec3(0.20, 0.50, 0.15);
uniform vec3 rock          : source_color = vec3(0.40, 0.35, 0.30);
uniform vec3 snow          : source_color = vec3(0.90, 0.90, 0.95);

varying vec3 local_pos;
 
void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	float e = texture(noise_tex, (local_pos + seed_offset)*noise_scale).r;
	
	vec3 col;
	
	if(e < sea_level - 0.05){
		col = mix(deep_water, shallow_water, smoothstep(sea_level - 0.25, sea_level - 0.05, e));
	}
	else if(e < sea_level + 0.02){
		col = sand;
	}
	else if(e < sea_level + 0.20){
		col = mix(grass, rock, smoothstep(sea_level + 0.05, sea_level + 0.20, e));
	}
	else{
		col = mix(rock, snow, smoothstep(sea_level + 0.20, sea_level + 0.35, e));
	}
	
	ALBEDO = col;
	ROUGHNESS = e < sea_level ? 0.2:0.9;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
