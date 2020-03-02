varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform float lightBuckets;

varying vec4 v_lightColour;

void CommonLighting(inout vec4 baseColor) {
    baseColor *= clamp(floor(v_lightColour * lightBuckets + vec4(0.5)) / lightBuckets, vec4(0.), vec4(1.));
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

void main() {
    vec4 color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    CommonFog(color);
    
    gl_FragColor = color;
}