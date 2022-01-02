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

#pragma include("lighting.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_LightWorldNormal;
varying vec3 v_LightWorldPosition;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1)).xyz;
    v_LightWorldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0)).xyz;
}
// include("lighting.v.xsh")
#pragma include("fog.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_FogCameraRelativePosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_FogCameraRelativePosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1)).xyz;
}
// include("fog.v.xsh")

uniform vec2 u_WaterAlphaBounds;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    
    CommonLightSetup();
    CommonFogSetup();
    
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