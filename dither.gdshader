shader_type canvas_item;
render_mode skip_vertex_transform, unshaded;

const vec2 target_res = vec2(640.0, 480.0);

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;
const float colors_per_channel = 8.0;

void fragment() {
	vec2 uv = floor(SCREEN_UV * target_res) / target_res;
	vec3 color = texture(screen_texture, uv).rgb;
	vec3 quantized_color = floor(color * colors_per_channel) / colors_per_channel;
	COLOR = vec4(quantized_color, 1.0);
}
