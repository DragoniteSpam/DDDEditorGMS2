/// https://github.com/GameMakerDiscord/Xpanda

uniform float lightBuckets;

varying vec4 v_lightColour;

void CommonLighting(inout Vec4 baseColor) {
    baseColor *= floor(v_lightColour * lightBuckets + Vec4(0.5)) / lightBuckets;
}