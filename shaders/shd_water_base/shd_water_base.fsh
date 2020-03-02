varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform float lightBuckets;

varying vec4 v_lightColour;

void CommonLighting(inout vec4 baseColor) {
    baseColor *= floor(v_lightColour * lightBuckets + vec4(0.5)) / lightBuckets;
}
// include("lighting.f.xsh")
#pragma include("fog.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform int fogEnabled;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

varying vec3 v_worldPosition;
varying vec3 v_cameraPosition;

void CommonFog(inout vec4 baseColor) {
    if (fogEnabled == 1) {
        float dist = length(v_worldPosition - v_cameraPosition);
        float f = clamp((dist - fogStart) / (fogEnd - fogStart), 0., 1.);
        baseColor.rgb = mix(baseColor.rgb, fogColor, f);
    }
}
// include("fog.f.xsh")

uniform sampler2D displacementMap;
uniform float displacement;
uniform vec2 time;

void main() {
    vec4 colorDM = texture2D(displacementMap, v_vTexcoord - vec2(mod(2. * time.x / 10., 1.), mod(-time.y / 10., 1.)));
    vec2 offset = vec2((colorDM.r + colorDM.g + colorDM.b) / 3. - 0.5) * displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + vec2(mod(time.x / 10., 1.), mod(time.y / 10., 1.)) + offset);
    
    CommonLighting(finalColor);
    CommonFog(finalColor);
    
    gl_FragColor = finalColor;
}