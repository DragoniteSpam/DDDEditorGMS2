// Utility shader:
// render filled 3D mesh as a wireframe only (requires a normal attribute which contains the barycentric)

attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour0;
attribute vec3 in_Colour1;

varying vec3 v_colour;
varying vec3 v_barycentric;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_colour = in_Colour0.rgb;
    v_barycentric = in_Colour1;
}