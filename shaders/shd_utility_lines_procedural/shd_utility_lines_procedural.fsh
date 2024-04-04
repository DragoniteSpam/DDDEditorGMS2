uniform vec3 u_GridColor;
uniform vec2 u_GridSize;
uniform float u_GridThickness;

varying vec2 v_vWorldPosition;

void main() {
    vec2 rounded = mod(v_vWorldPosition, u_GridSize);
    float closest = min(
        min(rounded.x, rounded.y),
        min(u_GridSize.x - rounded.x, u_GridSize.y - rounded.y)
    );
    
    gl_FragColor.rgb = u_GridColor;
    gl_FragColor.a = 1.0 - floor(closest / u_GridThickness);
}