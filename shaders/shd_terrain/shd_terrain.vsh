attribute vec3 in_Position;

varying vec2 v_vWorldXY;

//#pragma include("lighting.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_LightWorldNormal;
varying vec3 v_LightWorldPosition;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.)).xyz;
    //v_LightWorldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
}
// include("lighting.v.xsh")
#pragma include("fog.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_FogCameraRelativePosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_FogCameraRelativePosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.)).xyz;
}
// include("fog.v.xsh")

void main() {
    CommonLightSetup();
    CommonFogSetup();
    
    v_vWorldXY = in_Position.xy;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
}