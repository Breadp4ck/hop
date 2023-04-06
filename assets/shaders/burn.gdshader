shader_type spatial;
render_mode cull_disabled;

instance uniform vec4 emission_color : source_color = vec4(1);
uniform float emission_amount;

uniform sampler2D dissolve_texture;
uniform float burn_size : hint_range(0, 2);
instance uniform float dissolve_amount : hint_range(-0.5, 0.5);

void fragment() {
  ALBEDO = emission_color.rgb;

  float amount = 1.0 - 2.0*abs(dissolve_amount);
  float sample = texture(dissolve_texture, UV).r;

  float emission_value = 1.0 - smoothstep(amount, amount + burn_size, sample);

  EMISSION = vec3(emission_value * emission_amount * emission_color.rgb);
  ALPHA = emission_value;
}
