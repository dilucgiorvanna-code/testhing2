shader_type canvas_item;

uniform float distortion = 0.02;
uniform float fade_size : hint_range(0.0,0.5) = 0.25;

float rand(vec2 p){
    return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);
}

void fragment(){

    vec2 uv = UV;

    float wave = sin(uv.y*180.0 + TIME*18.0);

    uv.x += wave * distortion;

    float tear = step(0.97, rand(vec2(floor(TIME*20.0), floor(uv.y*180.0))));

    uv.x += tear * 0.08;

    float noise = rand(floor(uv*450.0)+floor(TIME*50.0));

    vec3 col = vec3(noise);

    col += tear * 0.8;

    float edge = min(
        min(UV.x,1.0-UV.x),
        min(UV.y,1.0-UV.y)
    );

    float alpha = smoothstep(0.0,fade_size,edge);

    COLOR = vec4(col, alpha);
}