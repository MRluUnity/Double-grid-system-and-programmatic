shader_type canvas_item;

uniform float gridSize : hint_range(0, 256, 1) = 256;
uniform float gridWidth : hint_range(0, 10, 0.01) = 1;

uniform vec4 colorLine : source_color;

varying vec2 worldPos;

void vertex()
{
    worldPos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec2 fraction = vec2(gridSize);
    vec2 worldPosFraction = abs(mod(worldPos  + vec2(gridSize / 2.), fraction) - fraction * 0.5);
    float dist = 1.0 - min(smoothstep(0.0, gridWidth, worldPosFraction.x), 
							smoothstep(0.0, gridWidth, worldPosFraction.y));
    COLOR = mix(COLOR, colorLine, dist);
}