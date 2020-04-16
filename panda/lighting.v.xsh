/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 16
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

uniform int lightEnabled;
uniform float lightBuckets;
uniform Vec3 lightAmbientColor;
uniform Vec4 lightData[MAX_LIGHTS * 3];

varying Vec4 v_lightColour;

void CommonLightEvaluate(int i, inout vec4 finalColor, Vec3 worldPosition, Vec3 worldNormal);
void CommonLightingSetup(Vec3 worldPosition, Vec3 worldNormal);

void CommonLightingSetup(Vec3 worldPosition, Vec3 worldNormal) {
    if (lightEnabled == 0) {
        v_lightColour = Vec4(1.);
        return;
    }
    
    Vec4 finalColor = Vec4(lightAmbientColor, 1.);
    
    CommonLightEvaluate(0, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(1, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(2, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(3, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(4, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(5, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(6, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(7, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(8, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(9, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(10, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(11, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(12, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(13, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(14, finalColor, worldPosition, worldNormal);
    CommonLightEvaluate(15, finalColor, worldPosition, worldNormal);
    
    v_lightColour = finalColor;
}

void CommonLightEvaluate(int i, inout Vec4 finalColor, in Vec3 worldPosition, in Vec3 worldNormal) {
    Vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    Vec4 lightExt = lightData[i * 3 + 1];
    Vec4 lightColor = lightData[i * 3 + 2];
    
    // in_Colour is not actually applied here - this just calculates the strength
    // of the light and passes it to the fragment shader for it to deal with
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        Vec3 lightDir = -normalize(lightPosition);
        float NdotL = max(dot(worldNormal, lightDir), 0.);
        finalColor += lightColor * NdotL;
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        Vec3 lightDir = worldPosition - lightPosition;
        float dist = length(lightDir);
        float att = clamp((1. - dist * dist / (range * range)), 0., 1.);
        lightDir /= dist;
        att *= att;
        finalColor += lightColor * max(0., -dot(worldNormal, lightDir)) * att;
    } else if (type == LIGHT_SPOT) {
    
    }
}