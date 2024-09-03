shader_type canvas_item;

uniform float amount : hint_range(0.0, 1.0, 0.0);
uniform vec2 aspect = vec2(1,1);
uniform bool flip;

void fragment() {
	float a = amount * (1.0 + aspect.x);
	vec2 uv = flip? UV * aspect : (vec2(1,1) - UV) * aspect;
	if(uv.x + uv.y > a){
		discard;
	}
}
