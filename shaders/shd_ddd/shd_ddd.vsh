attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour0;
attribute vec3 in_Colour1;                                                      // tangent
attribute vec3 in_Colour2;                                                      // bitangent
attribute vec3 in_Colour3;                                                      // barycentric

varying float v_FragDistance;
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

uniform float u_DrawVertexColors;

void main() {
    vec4 worldPosition = vec4(in_Position, 1);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * worldPosition;
    v_FragDistance = length((gm_Matrices[MATRIX_WORLD_VIEW] * worldPosition).xyz);
    
    CommonLightSetup();
    CommonFogSetup();
    
    v_vTexcoord = in_TextureCoord;
    
    if (u_DrawVertexColors != 0.0) {
        v_vColour = in_Colour0;
    } else {
        v_vColour = vec4(1);
    }
    vec3 tangent = in_Colour1;
    vec3 bitangent = in_Colour2;
    v_vBarycentric = in_Colour3;
}