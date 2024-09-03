shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest, repeat_disable;

uniform float strength : hint_range(0.0, 1.0, 0.0);

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


void fragment() {
	vec2 uv = vec2(random(UV) * 2.0 - 1.0, random(vec2(1.0 - UV.x, 1.0 - UV.y)) * 2.0 - 1.0);
	COLOR = texture(SCREEN_TEXTURE, UV + (uv * strength));
}
