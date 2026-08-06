shader_type canvas_item;

uniform float speed = 0.35;
uniform float swirl = 5.0;
uniform float scale = 12.0;
uniform float fade_size : hint_range(0.0, 0.5) = 0.25;

float hash(vec2 p){
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));

    vec2 u = f*f*(3.0-2.0*f);

    return mix(a,b,u.x)+(c-a)*u.y*(1.0-u.x)+(d-b)*u.x*u.y;
}

void fragment(){

    vec2 uv = UV - 0.5;

    float r = length(uv);
    float a = atan(uv.y, uv.x);

    a += TIME * speed + r * swirl;

    uv = vec2(cos(a), sin(a)) * r;

    float n = noise(uv * scale);

    float alpha = smoothstep(0.35, 0.8, n);

    float edge = min(
        min(UV.x,1.0-UV.x),
        min(UV.y,1.0-UV.y)
    );

    alpha *= smoothstep(0.0, fade_size, edge);

    COLOR = vec4(0.0,0.0,0.0,alpha);
}