uniform vec3 u_GridColor;
uniform vec2 u_GridSize;
uniform float u_GridThickness;

uniform float u_CursorEnabled;
uniform vec3 u_CursorPosition;
uniform vec3 u_CursorAffectHalfSize;

varying vec3 v_vWorldPosition;

void main() {
    vec2 rounded = mod(v_vWorldPosition.xy, u_GridSize);
    float closest = min(
        min(rounded.x, rounded.y),
        min(u_GridSize.x - rounded.x, u_GridSize.y - rounded.y)
    );
    
    gl_FragColor.rgb = u_GridColor;
    gl_FragColor.a = 1.0 - floor(closest / u_GridThickness);
    
    if (u_CursorEnabled > 0.5) {
        vec3 cursor_diff = abs(u_CursorPosition - v_vWorldPosition);
        if (cursor_diff.x < u_CursorAffectHalfSize.x && cursor_diff.y < u_CursorAffectHalfSize.y && cursor_diff.z < u_CursorAffectHalfSize.z) {
            gl_FragColor.rgb = vec3(1, 0, 0);
        }
    }
}