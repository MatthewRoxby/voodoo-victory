shader_type canvas_item;

uniform vec4 col : source_color = vec4(1,1,1,1);
uniform float strength = 0.0;

void fragment() {
	vec4 t = texture(TEXTURE,UV);
	COLOR.rgb = mix(t.rgb, col.rgb, strength);
	COLOR.a = t.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
