// Utility shader:
// render filled 3D mesh as solid color, determined only by a uniform

attribute vec3 in_Position;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
}