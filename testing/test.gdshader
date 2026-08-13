shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// =========================
// MASTER
// =========================

uniform float opacity : hint_range(0.0, 1.0) = 0.6;

// =========================
// VHS SETTINGS
// =========================

uniform float noise_intensity : hint_range(0.0, 1.0) = 0.15;
uniform float scanline_intensity : hint_range(0.0, 0.5) = 0.08;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.01;
uniform float chromatic_shift : hint_range(0.0, 0.02) = 0.003;

uniform float glitch_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

// =========================
// RANDOM
// =========================

float rand(vec2 co){
	return fract(
		sin(dot(co, vec2(12.9898,78.233)))
		* 43758.5453
	);
}

void fragment(){

	vec2 uv = SCREEN_UV;

	vec4 original = texture(SCREEN_TEXTURE, uv);

	// -------------------------
	// DISTORTION
	// -------------------------

	uv.x += sin(uv.y * 50.0 + TIME) * distortion_strength;
	uv.x += sin(uv.y * 120.0 - TIME) * distortion_strength * 0.4;
	uv.x += sin(TIME) * 0.0015;

	vec4 base = texture(SCREEN_TEXTURE, uv);

	// -------------------------
	// RGB SPLIT
	// -------------------------

	base.r = texture(SCREEN_TEXTURE, uv + vec2(chromatic_shift,0.0)).r;
	base.g = texture(SCREEN_TEXTURE, uv).g;
	base.b = texture(SCREEN_TEXTURE, uv - vec2(chromatic_shift,1.0)).b;

	// -------------------------
	// STATIC
	// -------------------------

	float noise = rand(vec2(
		floor(uv.x*120.0 + TIME*12.0),
		floor(uv.y*250.0)
	));

	noise = (noise - 0.5) * 2.0;

	base.rgb += noise * noise_intensity;

	// -------------------------
	// MOVING BAND
	// -------------------------

	float band = sin(uv.y*25.0 + TIME*5.0);
	base.rgb += band * 0.08;

	// -------------------------
	// SCANLINES
	// -------------------------

	base.rgb -= sin(uv.y*900.0) * scanline_intensity;

	// -------------------------
	// GLITCH
	// -------------------------

	float glitch_timer = mod(TIME,10.0);

	if(glitch_timer < 0.35){

		float strength = 1.0 - glitch_timer/0.35;

		vec2 guv = uv;

		float slice = step(0.4, fract(uv.y*12.0));

		guv.x +=
			sin(uv.y*90.0 + TIME*80.0)
			*0.03
			*slice
			*strength;

		vec2 delta = uv - vec2(0.5);

		float dist = length(delta);

		float burst = smoothstep(0.35,0.0,dist);

		if(dist > 0.001){
			guv += normalize(delta)
				* burst
				* 0.04
				* strength;
		}

		vec4 broken = texture(SCREEN_TEXTURE, guv);

		float streak =
			step(
				0.96,
				sin((uv.x+uv.y+TIME*10.0)*120.0)
			);

		broken.rgb += streak * 0.4 * strength;

		base.rgb = mix(base.rgb, broken.rgb, glitch_opacity);
	}

	// -------------------------
	// BLACKOUT
	// -------------------------

	float blackout = mod(TIME,6.0);

	if(blackout < 0.1){
		base.rgb *= blackout / 0.1;
	}

	// -------------------------
	// GREYSCALE
	// -------------------------

	float grey_timer = mod(TIME,40.0);

	if(grey_timer < 5.0){

		float grey = dot(base.rgb, vec3(0.299,0.587,0.114));

		base.rgb = mix(
			base.rgb,
			vec3(grey),
			0.85
		);
	}

	// -------------------------
	// BRIGHTNESS
	// -------------------------

	base.rgb *= brightness;

	// -------------------------
	// MASTER OPACITY
	// -------------------------

	COLOR = mix(original, base, opacity);
}
