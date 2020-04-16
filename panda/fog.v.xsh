/// https://github.com/GameMakerDiscord/Xpanda

varying Vec3 v_worldPosition;
varying Vec3 v_cameraPosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_cameraPosition = Vec3(gm_Matrices[MATRIX_WORLD][0][3], gm_Matrices[MATRIX_WORLD][1][3], gm_Matrices[MATRIX_WORLD][2][3]);
    v_worldPosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * Vec4(in_Position, 1.)).xyz;
}