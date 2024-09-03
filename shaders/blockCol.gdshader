shader_type canvas_item;

uniform vec3 col : source_color;

void fragment() {
	COLOR.rgb = col;
	COLOR.a *= 1.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
