// Utility shader:
// render filled 3D mesh as a wireframe only (requires a normal attribute which contains the barycentric)

attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;

varying vec3 v_barycentric;
varying vec4 v_colour;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_barycentric = in_Normal;
    v_colour = in_Colour;
}