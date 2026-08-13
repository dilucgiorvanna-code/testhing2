shader_type canvas_item;

uniform vec4 blood : source_color = vec4(0.45,0.0,0.0,1.0);
uniform float speed = 0.2;
uniform float fade_size : hint_range(0.0,0.5) = 0.25;

float hash(float x){
    return fract(sin(x*47.3)*43758.5);
}

void fragment(){

    vec2 uv = UV;

    float column = floor(uv.x*25.0);

    float offset = hash(column);

    float drip = fract(uv.y + TIME*speed + offset);

    float width = 0.25 + hash(column*3.7)*0.3;

    float edgeMask = smoothstep(width,width+0.05,drip);

    float wobble = sin(TIME*4.0 + uv.y*20.0 + column)*0.01;

    edgeMask *= smoothstep(0.0,0.2,abs(fract(uv.x*25.0)-0.5)+wobble);

    float edge = min(
        min(UV.x,1.0-UV.x),
        min(UV.y,1.0-UV.y)
    );

    edgeMask *= smoothstep(0.0,fade_size,edge);

    COLOR = vec4(blood.rgb, edgeMask);
}