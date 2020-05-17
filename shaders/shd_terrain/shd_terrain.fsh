varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vWorldXY;

uniform vec2 mouse;
uniform float mouseRadius;

const vec4 cursorColor = vec4(0.6, 0., 0., 1.);

#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform float lightBuckets;

varying vec4 v_lightColour;

void CommonLighting(inout vec4 baseColor);

void CommonLighting(inout vec4 baseColor) {
    baseColor *= clamp(floor(v_lightColour * lightBuckets + vec4(0.5)) / lightBuckets, vec4(0.), vec4(1.));
}
// include("lighting.f.xsh")
#pragma include("fog.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

uniform float fogStrength;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

varying vec3 v_worldPosition;
varying vec3 v_cameraPosition;

void CommonFog(inout vec4 baseColor);

void CommonFog(inout vec4 baseColor) {
    float dist = length(v_worldPosition - v_cameraPosition);
    float f = clamp((dist - fogStart) / (fogEnd - fogStart) * fogStrength, 0., 1.);
    baseColor.rgb = mix(baseColor.rgb, fogColor, f);
}
// include("fog.f.xsh")

void main() {
    vec4 color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    CommonLighting(color);
    CommonFog(color);
    
    float r = mouseRadius;
    float dist = length(v_vWorldXY - mouse);
    float strength = max(min(-2. / pow(r, 2.) * (dist + r) * (dist - r), 1.), 0.);
    color = mix(color, cursorColor, strength);
    
    gl_FragColor = color;
}