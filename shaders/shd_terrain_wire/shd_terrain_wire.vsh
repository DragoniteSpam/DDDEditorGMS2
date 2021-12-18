attribute vec3 in_Position;
attribute vec3 in_Normal;

varying vec3 v_vBarycentric;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
}