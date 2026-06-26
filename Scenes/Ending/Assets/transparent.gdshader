shader_type canvas_item;

uniform float alpha_value = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// generate random noise
	
	vec4 texture_color = texture(TEXTURE, UV);
	
	if (texture_color.a != 0.0){
		COLOR.a = alpha_value;
	}
		
	
	// Called for every pixel the material is visible on.
}
