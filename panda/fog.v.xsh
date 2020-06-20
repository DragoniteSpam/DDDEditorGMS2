/// https://github.com/GameMakerDiscord/Xpanda

varying Vec3 v_worldPosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_worldPosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * Vec4(in_Position, 1.)).xyz;
}