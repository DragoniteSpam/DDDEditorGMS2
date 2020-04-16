/// https://github.com/GameMakerDiscord/Xpanda

uniform float fogStrength;
uniform float fogStart;
uniform float fogEnd;
uniform Vec3 fogColor;

varying Vec3 v_worldPosition;
varying Vec3 v_cameraPosition;

void CommonFog(inout Vec4 baseColor);

void CommonFog(inout Vec4 baseColor) {
    float dist = length(v_worldPosition - v_cameraPosition);
    float f = clamp((dist - fogStart) / (fogEnd - fogStart) * fogStrength, 0., 1.);
    baseColor.rgb = Lerp(baseColor.rgb, fogColor, f);
}