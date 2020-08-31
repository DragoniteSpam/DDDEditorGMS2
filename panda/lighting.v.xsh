/// https://github.com/GameMakerDiscord/Xpanda

varying Vec3 v_LightWorldNormal;
varying Vec3 v_LightWorldPosition;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * Vec4(in_Position, 1.)).xyz;
    v_LightWorldNormal = normalize(gm_Matrices[MATRIX_WORLD] * Vec4(in_Normal, 0.)).xyz;
}