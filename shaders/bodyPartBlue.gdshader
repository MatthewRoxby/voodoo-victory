shader_type canvas_item;

uniform vec2 scale;

uniform float speed;

uniform float point_size;
uniform sampler2D modulate;


vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

void fragment() {
	float worley = worley(UV + vec2(sin(TIME) * 0.2,TIME * speed), scale.x, scale.y);
	
	vec4 tex = texture(TEXTURE,UV);
	COLOR.rgb = tex.rgb * texture(modulate, vec2(worley, 0.0)).rgb;
	COLOR.a = tex.a;
	
}

