shader_type canvas_item;

uniform float fade_size : hint_range(0.0,0.5) = 0.15;

float rand(vec2 p){
    return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);
}

void fragment(){

    vec2 uv = floor(UV*400.0);

    float n = rand(uv + floor(TIME*60.0));

    float edge = min(
        min(UV.x,1.0-UV.x),
        min(UV.y,1.0-UV.y)
    );

    float alpha = smoothstep(0.0,fade_size,edge);

    COLOR = vec4(vec3(n), alpha);
}