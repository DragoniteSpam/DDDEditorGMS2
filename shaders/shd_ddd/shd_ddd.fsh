varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 16
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

varying vec3 v_LightWorldNormal;
varying vec3 v_LightWorldPosition;

uniform float lightBuckets;
uniform vec3 lightAmbientColor;
uniform vec4 lightData[MAX_LIGHTS * 3];
uniform vec3 lightDayTimeColor;
uniform vec3 lightWeatherColor;

void CommonLightEvaluate(int i, inout vec4 finalColor);
void CommonLight(inout vec4 baseColor);

void CommonLight(inout vec4 baseColor) {
    vec4 lightColor = vec4(lightAmbientColor * lightDayTimeColor * lightWeatherColor, 1.);
    
    CommonLightEvaluate(0, lightColor);
    CommonLightEvaluate(1, lightColor);
    CommonLightEvaluate(2, lightColor);
    CommonLightEvaluate(3, lightColor);
    CommonLightEvaluate(4, lightColor);
    CommonLightEvaluate(5, lightColor);
    CommonLightEvaluate(6, lightColor);
    CommonLightEvaluate(7, lightColor);
    CommonLightEvaluate(8, lightColor);
    CommonLightEvaluate(9, lightColor);
    CommonLightEvaluate(10, lightColor);
    CommonLightEvaluate(11, lightColor);
    CommonLightEvaluate(12, lightColor);
    CommonLightEvaluate(13, lightColor);
    CommonLightEvaluate(14, lightColor);
    CommonLightEvaluate(15, lightColor);
    
    baseColor *= clamp(lightColor, vec4(0.), vec4(1.));
}

void CommonLightEvaluate(int i, inout vec4 finalColor) {
    vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    vec4 lightExt = lightData[i * 3 + 1];
    vec4 lightColor = lightData[i * 3 + 2];
    
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        vec3 lightDir = -normalize(lightPosition);
        finalColor += lightColor * max(dot(v_LightWorldNormal, lightDir), 0.);
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        float att = pow(clamp((1. - dist * dist / (range * range)), 0., 1.), 2.);
        lightDir = normalize(lightDir);
        finalColor += lightColor * max(0., -dot(v_LightWorldNormal, lightDir)) * att;
    } else if (type == LIGHT_SPOT) {
        
    }
}
// include("lighting.f.xsh")
#pragma include("fog.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_FogCameraRelativePosition;

uniform float fogStrength;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

void CommonFog(inout vec4 baseColor);

void CommonFog(inout vec4 baseColor) {
    float dist = length(v_FogCameraRelativePosition);
    float f = clamp((dist - fogStart) / (fogEnd - fogStart) * fogStrength, 0., 1.);
    baseColor.rgb = mix(baseColor.rgb, fogColor, f);
}
// include("fog.f.xsh")

// not sure why this works but gm_AlphaRefValue is not
#define ALPHA_REF 0.2

void main() {
    vec4 color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    CommonLight(color);
    CommonFog(color);
    
    if (color.a < ALPHA_REF) {
        discard;
    }
    
    gl_FragColor = color;
}