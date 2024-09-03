shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest, repeat_disable;

uniform vec2 circle_pos;

uniform vec2 aspect;

uniform float circle_radius;

void fragment() {
	vec2 uv = UV * aspect;
	vec2 p = circle_pos * aspect;
	if(distance(uv, p) < circle_radius){
		discard;
	}
	
	COLOR.rgb = vec3(1,1,1) * (length(texture(SCREEN_TEXTURE, UV).rgb) / 3.0);
}