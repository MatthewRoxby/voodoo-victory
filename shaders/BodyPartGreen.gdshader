shader_type canvas_item;

uniform vec2 size;

uniform vec4 col1 : source_color;
uniform vec4 col2 : source_color;

uniform float move_speed = 1.0;
uniform float sin_speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = fract(UV * size + vec2(1,1) * TIME * move_speed);
	vec4 tex = texture(TEXTURE,UV);
	
	float sep = sin(TIME * sin_speed) * 0.4;
	
	vec4 b = col1;
	if(uv.x + sep > uv.y && 1.0 - uv.x + sep > uv.y){
		b = col2;
	}
	
	if(uv.x - sep < uv.y && 1.0 - uv.x - sep < uv.y){
		b = col2;
	}
	
	COLOR = vec4(tex.rgb * b.rgb, tex.a);
}
