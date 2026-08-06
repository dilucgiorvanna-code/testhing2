shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// VHS SETTINGS
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.15;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.08;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.01;
uniform float chromatic_shift : hint_range(0.0, 0.02) = 0.004;

uniform float glitch_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float blackout_strength : hint_range(0.0, 1.0) = 1.0;

// RANDOM
float rand(vec2 co){
	return fract(
		sin(dot(co, vec2(12.9898, 78.233)))
		* 43758.5453
	);
}

void fragment() {

	vec2 uv = SCREEN_UV;

	// =========================
	// VHS WAVE DISTORTION
	// =========================

	float wave1 =
		sin(uv.y * 50.0 + TIME * 3.0)
		* distortion_strength;

	float wave2 =
		sin(uv.y * 120.0 - TIME * 1.0)
		* distortion_strength
		* 0.4;

	uv.x += wave1 + wave2;

	// Tape jitter
	uv.x += sin(TIME * 1.0) * 0.0015;

	// =========================
	// SCREEN SAMPLE
	// =========================

	vec4 base = texture(SCREEN_TEXTURE, uv);

	// RGB SHIFT
	float r = texture(
		SCREEN_TEXTURE,
		uv + vec2(chromatic_shift, 0.0)
	).r;

	float g = texture(
		SCREEN_TEXTURE,
		uv
	).g;

	float b = texture(
		SCREEN_TEXTURE,
		uv - vec2(chromatic_shift, 0.0)
	).b;

	base.rgb = vec3(r, g, b);

	// =========================
	// VHS STATIC
	// =========================

	float static_noise =
		rand(vec2(
			floor(uv.x * 100.0 + TIME * 10.0),
			floor(uv.y * 250.0)
		));

	static_noise -= 2.3;

	base.rgb += static_noise * noise_intensity;

	// Moving static bands
	float band =
		sin((uv.y * 25.0) + TIME * 6.0);

	base.rgb += band * 0.1;

	// =========================
	// SCANLINES
	// =========================

	float scanlines =
		sin(uv.y * 900.0)
		* scanline_intensity;

	base.rgb -= scanlines;

	// =========================
	// BROKEN SCREEN GLITCH
	// Every 10 seconds
	// =========================

	float glitch_timer = mod(TIME, 10.0);

	if (glitch_timer < 0.35) {

		float strength =
			1.0 - (glitch_timer / 0.35);

		vec2 glitch_uv = uv;

		// Horizontal tearing slices
		float slice =
			step(
				0.4,
				fract(uv.y * 12.0)
			);

		glitch_uv.x +=
			sin(uv.y * 90.0 + TIME * 80.0)
			* 0.03
			* slice
			* strength;

		// "Punched screen" distortion
		vec2 center = vec2(0.5, 0.5);

		vec2 delta = uv - center;

		float dist = length(delta);

		float burst =
			smoothstep(0.35, 0.0, dist);

		if (dist > 0.001) {
			glitch_uv +=
				normalize(delta)
				* burst
				* 0.04
				* strength;
		}

		// Distorted sample
		vec4 broken =
			texture(
				SCREEN_TEXTURE,
				glitch_uv
			);

		// Fracture streaks
		float streaks =
			step(
				0.96,
				sin(
					(uv.x + uv.y + TIME * 10.0)
					* 120.0
				)
			);

		broken.rgb +=
			streaks
			* 0.25
			* strength;

		base.rgb = mix(
			base.rgb,
			broken.rgb,
			glitch_opacity
		);
	}

	// =========================
	// BLACKOUT
	// Every 6 seconds
	// =========================

	float blackout_timer = mod(TIME, 6.0);

	if (blackout_timer < 0.10) {

		float fade =
			blackout_timer / 0.10;

		base.rgb *= fade;
	}

	// =========================
	// GREYSCALE MODE
	// 5 seconds every 40 seconds
	// =========================

	float grey_timer = mod(TIME, 40.0);

	if (grey_timer < 5.0) {

		float grey =
			dot(
				base.rgb,
				vec3(0.299, 0.587, 0.114)
			);

		vec3 grey_color =
			vec3(grey);

		base.rgb = mix(
			base.rgb,
			grey_color,
			0.85
		);
	}

	// =========================
	// VHS DARKENING
	// =========================

	base.rgb *= 0.65;

	COLOR = base;
}