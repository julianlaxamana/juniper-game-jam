shader_type canvas_item;

uniform float alpha_value = 0.0;
uniform float seed_delta = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// generate random noise
	float noise = fract(sin(dot(UV.xy, vec2(12.9898, 78.233))) * 45671.1247895 * seed_delta);
	//COLOR = vec4(vec3(noise), alpha_value);
	
	vec4 texture_color = texture(TEXTURE, UV);
	
	if (texture_color.a != 0.0){
		COLOR = mix(texture_color, vec4(vec3(noise), 1), alpha_value);
	}
		
	
	// Called for every pixel the material is visible on.
}
