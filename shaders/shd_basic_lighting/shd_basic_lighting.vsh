attribute vec3 in_Position;                 // (x,y,z)
attribute vec3 in_Normal;                   // (x,y,z)
attribute vec2 in_TextureCoord;             // (u,v)
attribute vec4 in_Colour;                   // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#pragma include("lighting.xsh")
/// https://github.com/GameMakerDiscord/Xpanda
#define MAX_LIGHTS 8
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

uniform int lightEnabled;
uniform int lightCount;
uniform vec4 lightData[MAX_LIGHTS * 3];

vec4 CommonLighting(vec3 worldPosition, vec3 worldNormal) {
    if (lightEnabled == 0) {
        return vec4(0., 0., 0., 0.);
    }
    
    vec4 finalColor = vec4(0.);
    // min isn't overloaded to work with ints, that's interesting
    int n = int(min(float(lightCount), float(MAX_LIGHTS)));
    
    for (int i = 0; i < n; i++) {
        vec3 lightPosition = lightData[i * 3].xyz;
        float type = lightData[i * 3].w;
        vec4 lightExt = lightData[i * 3 + 1];
        vec4 lightColor = lightData[i * 3 + 2];
        
        if (type == LIGHT_DIRECTIONAL) {
            // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
            vec3 lightDir = -normalize(lightPosition);
            float NdotL = max(dot(worldNormal, lightDir), 0.);
            finalColor += lightColor * NdotL * in_Colour;
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
    
    return finalColor;
}
// include("lighting.xsh")

void main() {
    vec4 position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    vec3 worldNormal = normalize(gm_Matrices[MATRIX_WORLD] * vec4(in_Normal, 0.)).xyz;
    vec3 worldPosition = vec3(gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.));
    
    vec4 finalColor = CommonLighting(worldPosition, worldNormal);
    
    v_vColour = vec4(min(finalColor, vec4(1.)).rgb, in_Colour.a);
    gl_Position = position;
    v_vTexcoord = in_TextureCoord;
}