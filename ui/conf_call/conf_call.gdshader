shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	float add = sin(2.f * PI * 0.16f * VERTEX.g - (TIME * 40.f)) / 30.f;
	COLOR = vec4(bg.r + add, bg.g + add, bg.b + add, 1.f);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
