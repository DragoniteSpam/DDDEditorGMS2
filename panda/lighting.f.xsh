/// https://github.com/GameMakerDiscord/Xpanda

uniform float lightBuckets;

varying vec4 v_lightColour;

void CommonLighting(inout Vec4 baseColor);

void CommonLighting(inout Vec4 baseColor) {
    baseColor *= clamp(floor(v_lightColour * lightBuckets + Vec4(0.5)) / lightBuckets, Vec4(0.), Vec4(1.));
}