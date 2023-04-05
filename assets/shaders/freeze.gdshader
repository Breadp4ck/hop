shader_type spatial;

uniform sampler2D noise;
uniform vec4 ice_color: source_color;
instance uniform float ice_strength: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	
	float modifier = texture(noise, UV).r;
   
	ALBEDO = ice_color.xyz;
	ALPHA = (ice_strength+modifier/10.0) * 0.5;
}