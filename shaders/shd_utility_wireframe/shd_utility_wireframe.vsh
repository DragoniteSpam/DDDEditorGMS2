// Utility shader:
// render filled 3D mesh as a wireframe only (requires a normal attribute which contains the barycentric)

attribute vec3 in_Position;
attribute vec3 in_Normal0;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour;
attribute vec3 in_Normal1;

varying vec3 v_barycentric;
varying vec4 v_colour;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    vec3 please_dont_optimize_this = in_Normal0;
    please_dont_optimize_this.xy = in_TextureCoord;
    v_barycentric = in_Normal1;
    v_colour = in_Colour;
}