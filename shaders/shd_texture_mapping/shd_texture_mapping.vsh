attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour0;
attribute vec3 in_Colour1;                                                      // tangent
attribute vec3 in_Colour2;                                                      // bitangent
attribute vec3 in_Colour3;                                                      // barycentric

varying vec3 v_vBarycentric;

void main() {
    // thanks opengl
    vec3 pos = in_Position;
    vec3 norm = in_Normal;
    vec4 c = in_Colour0;
    vec3 c1 = in_Colour1;
    vec3 c2 = in_Colour2;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_TextureCoord, 0, 1);
    v_vBarycentric = in_Colour3;
}