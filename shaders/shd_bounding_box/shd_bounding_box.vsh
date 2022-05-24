attribute vec3 in_Position;
attribute vec4 in_Colour;

varying vec4 v_vColour;

uniform vec4 actual_color;
uniform vec3 offsets[8];

void main() {
    // this is (r | (g << 1) | (b << 2)) except you can't actually do those operations
    // in OpenGL ES apparently, so i'm settling for the next best thing
    int index = int(floor(in_Colour.r)) + int(floor(in_Colour.g)) * 2 + int(floor(in_Colour.b)) * 4;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(offsets[index] + in_Position, 1.);
    
    v_vColour = vec4(actual_color.rgb, in_Colour.a);
}