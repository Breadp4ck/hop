shader_type spatial;
render_mode unshaded, depth_draw_never;

instance uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float cycle_interval : hint_range(0.1, 5.0) = 3.0;

instance uniform float shine_speed : hint_range(1.0, 5.0) = 1.0;
instance uniform float shine_width : hint_range(1.0, 100.0) = 5.0;
instance uniform float shine_tangent : hint_range(-1.0, 1.0) = 0.0;

void fragment() {
  vec3 vertex = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

  float width = shine_width * 0.001 * cycle_interval;
  float frequency =
      floor(sin(vertex.z + shine_tangent * vertex.y * cycle_interval +
                TIME * shine_speed * cycle_interval) +
            width);

  ALBEDO = shine_color.rgb;
  ALPHA =
      clamp((1.0 - dot(NORMAL, VIEW)) * frequency * shine_color.a, 0.0, 1.0);
}
