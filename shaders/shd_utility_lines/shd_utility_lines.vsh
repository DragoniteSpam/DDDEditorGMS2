// Utility shader:
// render a line strip vertex buffer, using only vertex color

attribute vec3 in_Position;
attribute vec4 in_Colour;

varying vec4 v_colour;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_colour = in_Colour;
}