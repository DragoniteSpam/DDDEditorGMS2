attribute vec3 in_Position;
attribute vec3 in_Normal;

varying vec3 v_barycentric;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_barycentric = in_Normal;
}