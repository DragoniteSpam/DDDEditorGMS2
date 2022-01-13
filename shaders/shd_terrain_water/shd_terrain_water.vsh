attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour0;
attribute vec3 in_Colour1;                                                      // tangent
attribute vec3 in_Colour2;                                                      // bitangent
attribute vec3 in_Colour3;                                                      // barycentric

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vBarycentric;

uniform vec2 u_WaterAlphaBounds;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    
    v_vTexcoord = in_TextureCoord;
    v_vColour = in_Colour0;
    vec3 tangent = in_Colour1;
    vec3 bitangent = in_Colour2;
    v_vBarycentric = in_Colour3;
    
    // nice water alpha
    vec3 eye_space_normal = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Normal, 0)).xyz;
    vec3 eye_space_camera = vec3(0, 0, 1);
    
    v_vColour.a = clamp(1.0 + dot(normalize(eye_space_camera), normalize(eye_space_normal)), u_WaterAlphaBounds.x, u_WaterAlphaBounds.y);
}