attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)
attribute vec4 extra;                       // not used here

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_LightWorldNormal;
varying vec3 v_LightWorldPosition;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.)).xyz;
    v_LightWorldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
}
// include("lighting.v.xsh")
#pragma include("fog.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_FogCameraRelativePosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_FogCameraRelativePosition = normalize((gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.)).xyz);
}
// include("fog.v.xsh")

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    v_vTexcoord = in_TextureCoord;
    v_vColour = in_Colour;
    
    CommonLightSetup();
    CommonFogSetup();
}