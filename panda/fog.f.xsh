/// https://github.com/GameMakerDiscord/Xpanda

uniform int fogEnabled;
uniform float fogStart;
uniform float fogEnd;
uniform Vec3 fogColor;

varying Vec3 v_worldPosition;
varying Vec3 v_cameraPosition;

void CommonFog(inout Vec4 baseColor) {
    if (fogEnabled == 1) {
        float dist = length(v_worldPosition - v_cameraPosition);
        float f = clamp((dist - fogStart) / (fogEnd - fogStart), 0., 1.);
        baseColor.rgb = Lerp(baseColor.rgb, fogColor, f);
    }
}