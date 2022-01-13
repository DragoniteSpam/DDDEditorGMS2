attribute vec3 in_Position;
attribute vec3 in_Normal;

varying float v_FragDistance;
varying vec3 v_vWorldPosition;
varying vec3 v_FragWorldPosition;
varying vec3 v_barycentric;

void main() {
    v_FragWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1)).xyz;
    v_FragDistance = length((gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 1)).xyz);
    
    v_vWorldPosition = vec3(floor(in_Position.xy), in_Position.z);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(v_vWorldPosition, 1);
    
    float f = fract(in_Position.x) * 8.0;
    v_barycentric = vec3(
        1.0 - min(abs(1.0 - f), 1.0),
        1.0 - min(abs(2.0 - f), 1.0),
        1.0 - min(abs(4.0 - f), 1.0)
    );
}