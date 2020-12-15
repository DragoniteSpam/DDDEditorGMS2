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
        // spot light: [x, y, z, type], [dx, dy, dz, range], [r, g, b, cutoff]
        float range = lightExt.w;
        vec3 sourceDir = normalize(lightExt.xyz);
        float cutoff = lightColor.w;
        
        vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        lightDir = normalize(lightDir);
        
        float lightAngleDifference = max(dot(lightDir, sourceDir), 0.);
        // this is very much hard-coding the cutoff radius but i dont really feel
        // like adding more shader attributes now
        float epsilon = (cos(acos(cutoff) * 0.75) - cutoff);
        float f = clamp((lightAngleDifference - cutoff) / epsilon, 0., 1.);
        float att = f * pow(clamp((1. - dist * dist / (range * range)), 0., 1.), 2.);
        
        finalColor += att * lightColor * max(0., -dot(v_LightWorldNormal, lightDir));
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

uniform sampler2D displacementMap;
uniform float displacement;
uniform vec2 time;
uniform float baseAlpha;

void main() {
    vec4 colorDM = texture2D(displacementMap, v_vTexcoord - vec2(mod(2. * time.x / 10., 1.), mod(-time.y / 10., 1.)));
    vec2 offset = vec2((colorDM.r + colorDM.g + colorDM.b) / 3. - 0.5) * displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + vec2(mod(time.x / 10., 1.), mod(time.y / 10., 1.)) + offset);
    
    CommonLight(finalColor);
    CommonFog(finalColor);
    
    finalColor.a = clamp(length(finalColor.rgb) / 2., 0., 1.) * baseAlpha;
    
    gl_FragColor = finalColor;
}