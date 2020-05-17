attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vWorldXY;

#pragma include("lighting.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 16
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

uniform float lightBuckets;
uniform vec3 lightAmbientColor;
uniform vec4 lightData[MAX_LIGHTS * 3];

varying vec4 v_lightColour;

void CommonLightEvaluate(int i, inout vec4 finalColor, vec3 worldPosition, vec3 worldNormal);
void CommonLightingSetup(vec3 worldPosition, vec3 worldNormal);

void CommonLightingSetup(vec3 worldPosition, vec3 worldNormal) {
    vec4 finalColor = vec4(lightAmbientColor, 1.);
    
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

void CommonLightEvaluate(int i, inout vec4 finalColor, in vec3 worldPosition, in vec3 worldNormal) {
    vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    vec4 lightExt = lightData[i * 3 + 1];
    vec4 lightColor = lightData[i * 3 + 2];
    
    // in_Colour is not actually applied here - this just calculates the strength
    // of the light and passes it to the fragment shader for it to deal with
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        vec3 lightDir = -normalize(lightPosition);
        float NdotL = max(dot(worldNormal, lightDir), 0.);
        finalColor += lightColor * NdotL;
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        vec3 lightDir = worldPosition - lightPosition;
        float dist = length(lightDir);
        float att = clamp((1. - dist * dist / (range * range)), 0., 1.);
        lightDir /= dist;
        att *= att;
        finalColor += lightColor * max(0., -dot(worldNormal, lightDir)) * att;
    } else if (type == LIGHT_SPOT) {
    
    }
}
// include("lighting.v.xsh")
#pragma include("fog.v.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

varying vec3 v_worldPosition;
varying vec3 v_cameraPosition;

void CommonFogSetup();

void CommonFogSetup() {
    v_cameraPosition = vec3(gm_Matrices[MATRIX_WORLD][0][3], gm_Matrices[MATRIX_WORLD][1][3], gm_Matrices[MATRIX_WORLD][2][3]);
    v_worldPosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.)).xyz;
}
// include("fog.v.xsh")

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 worldPosition = vec3(gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.));
    
    CommonLightingSetup(worldPosition, worldNormal);
    CommonFogSetup();
    
    v_vWorldXY = in_Position.xy;
    v_vColour = in_Colour;
    gl_Position = position;
    v_vTexcoord = in_TextureCoord;
}