attribute vec3 in_Position;

varying float v_LightDepth;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_LightDepth = gl_Position.z / gl_Position.w;
}