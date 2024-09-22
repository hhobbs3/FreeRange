shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;
uniform sampler2D normal_texture : source_color, hint_normal_roughness_texture, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, screen_uv).r;
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void fragment() {
	// Called for every pixel the material is visible on.
	// screen
	// vec3 original = texture(screen_texture, SCREEN_UV).rgb;
	// ALBEDO = original * 10.0;
	
	// normal
	// vec3 normal = texture(normal_texture, SCREEN_UV).rgb * 2.0 - 1.0;
	// ALBEDO = normal;
	
	// depth
	// float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	// ALBEDO = vec3(depth / 20.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
