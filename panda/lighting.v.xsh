/// https://github.com/GameMakerDiscord/Xpanda

varying Vec3 v_LightWorldNormal;
varying Vec3 v_LightWorldPosition;
varying vec3 v_EyeNormal;
varying vec3 v_Eye;
varying vec2 v_UV;

void CommonLightSetup();

void CommonLightSetup() {
    v_LightWorldPosition = (gm_Matrices[MATRIX_WORLD] * Vec4(in_Position, 1.)).xyz;
    v_LightWorldNormal = normalize(gm_Matrices[MATRIX_WORLD] * Vec4(in_Normal, 0.)).xyz;
    v_Eye = -(gm_Matrices[MATRIX_WORLD_VIEW] * Vec4(in_Position, 1.)).xyz;
    v_EyeNormal = normalize((gm_Matrices[MATRIX_WORLD_VIEW] * Vec4(in_Normal, 0)).xyz);
	v_UV = in_Texcoord;
}