varying vec2 v_vTexcoord;
varying vec4 v_vColour;

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

// not sure why this works but gm_AlphaRefValue is not
#define ALPHA_REF 0.2

void main() {
    vec4 color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (color.a < ALPHA_REF) {
        discard;
    }
    
    CommonFog(color);
    
    gl_FragColor = color;
}