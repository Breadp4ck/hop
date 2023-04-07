shader_type spatial;

instance uniform float progress: hint_range(0.0, 1.0) = 0.0;
instance uniform float radius: hint_range(0.0, 1.0) = 0.5;
instance uniform float width: hint_range(0.0, 0.5) = 0.05;

instance uniform float wobble: hint_range(0.0, 30.0) = 10.0;
instance uniform float squash: hint_range(1.0, 5.0) = 1.0;

instance uniform vec4 inner_color: source_color;
instance uniform vec4 border_color: source_color;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}


float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float amplitude = 0.5;
    float frequency = 3.0;
	float value = 0.0;
	
    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

void fragment() {
	vec2 uv = (UV  * 2.0 - 1.0) * vec2(squash, 1.0);
	float noise = fbm(uv  + TIME/10.0) * 2.0 - 1.0;
	float val = noise/wobble;
	float len = length(uv);
	if (len < radius - width + val) {
		ALBEDO = inner_color.xyz - noise/10.0;
		ALPHA = inner_color.w;
		EMISSION = inner_color.xyz - noise/10.0;
	} else if (len < radius + width + val) {
		ALBEDO = border_color.xyz;
		ALPHA = border_color.w;
	} else {
		ALPHA = 0.0;
	}
}
