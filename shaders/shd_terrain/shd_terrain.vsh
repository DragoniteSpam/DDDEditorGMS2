attribute vec3 in_Position;
attribute vec3 in_Normal;

varying vec2 v_vWorldXY;

//#pragma include("lighting.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_LightWorldPosition;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1)).xyz;
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

varying vec4 v_barycentric;

void main() {
    CommonLightSetup();
    CommonFogSetup();
    
    v_vWorldXY = floor(in_Position.xy);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(v_vWorldXY, in_Position.z, 1);
    
    float f = fract(in_Position.x) * 8.0;
    v_barycentric = vec4(
        // xyz
        1.0 - min(abs(1.0 - f), 1.0),
        1.0 - min(abs(2.0 - f), 1.0),
        1.0 - min(abs(4.0 - f), 1.0),
        // gl.z / gl.w would be nice but it's easier to do this with world space distance
        length(gm_Matrices[MATRIX_WORLD_VIEW] * vec4(v_vWorldXY, in_Position.z, 1)) / 128.0
    );
    
}