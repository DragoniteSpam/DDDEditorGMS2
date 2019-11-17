// super secret secret: none of these are actually used except for color, it's
// mostly just all here so that the default vertex format can be used (and even
// then, color isn't actually used to store color data).
attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 v_vColour;

uniform vec4 actual_color;
uniform vec3 offsets[8];

void main() {
    // this is (r | (g << 1) | (b << 2)) except you can't actually do those operations
    // in OpenGL ES apparently, so i'm settling for the next best thing
    int index = int(floor(in_Colour.r / 255.)) + int(floor(in_Colour.g / 255.)) * 2 + int(floor(in_Colour.b / 255.)) * 4;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(offsets[index], 1.);
    
    v_vColour = actual_color;
}