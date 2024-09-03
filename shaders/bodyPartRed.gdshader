shader_type canvas_item;

uniform float speed;
uniform vec2 size;
uniform vec3 wave1 : source_color;
uniform vec3 wave2 : source_color;
uniform float dist = 0.5;

void fragment(){
	vec4 tex = texture(TEXTURE,UV);
	float t1 = fract(length(UV * size) - TIME * speed);
	COLOR.rgb = tex.rgb * (t1 > dist? wave1 : wave2);
	COLOR.a = tex.a;
}