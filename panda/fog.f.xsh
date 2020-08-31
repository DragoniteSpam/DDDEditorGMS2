/// https://github.com/GameMakerDiscord/Xpanda

varying Vec3 v_FogCameraRelativePosition;

uniform float fogStrength;
uniform float fogStart;
uniform float fogEnd;
uniform Vec3 fogColor;

void CommonFog(inout Vec4 baseColor);

void CommonFog(inout Vec4 baseColor) {
    float dist = length(v_FogCameraRelativePosition);
    float f = clamp((dist - fogStart) / (fogEnd - fogStart) * fogStrength, 0., 1.);
    baseColor.rgb = mix(baseColor.rgb, fogColor, f);
}