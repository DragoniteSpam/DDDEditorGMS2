#extension GL_OES_standard_derivatives : enable

varying vec3 v_vWorldPosition;

uniform vec2 terrainSize;
uniform vec2 mouse;
uniform float mouseRadius;

uniform sampler2D texColor;
const vec4 cursorColor = vec4(0.6, 0., 0., 1.);

#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 8
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

varying vec3 v_LightWorldPosition;

uniform vec3 lightAmbientColor;
uniform vec4 lightData[MAX_LIGHTS * 3];
uniform vec3 lightDayTimeColor;
uniform vec3 lightWeatherColor;

void CommonLightEvaluate(int i, inout vec4 finalColor, in vec3 normal);
void CommonLight(inout vec4 baseColor);

void CommonLight(inout vec4 baseColor) {
    vec3 normal = cross(dFdx(v_LightWorldPosition), dFdy(v_LightWorldPosition));
    normal = normalize(normal * sign(normal.z));
    
    vec4 lightColor = vec4(lightAmbientColor * lightDayTimeColor * lightWeatherColor, 1);
    
    CommonLightEvaluate(0, lightColor, normal);
    CommonLightEvaluate(1, lightColor, normal);
    CommonLightEvaluate(2, lightColor, normal);
    CommonLightEvaluate(3, lightColor, normal);
    CommonLightEvaluate(4, lightColor, normal);
    CommonLightEvaluate(5, lightColor, normal);
    CommonLightEvaluate(6, lightColor, normal);
    CommonLightEvaluate(7, lightColor, normal);
    
    baseColor *= clamp(lightColor, vec4(0), vec4(1));
}

void CommonLightEvaluate(int i, inout vec4 finalColor, in vec3 normal) {
    vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    vec4 lightExt = lightData[i * 3 + 1];
    vec4 lightColor = lightData[i * 3 + 2];
    
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        vec3 lightDir = -normalize(lightPosition);
        finalColor += lightColor * max(dot(normal, lightDir), 0.0);
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        float att = pow(clamp((1.0 - dist * dist / (range * range)), 0.0, 1.0), 2.0);
        lightDir = normalize(lightDir);
        finalColor += lightColor * max(0.0, -dot(normal, lightDir)) * att;
    } else if (type == LIGHT_SPOT) {
        // spot light: [x, y, z, type], [dx, dy, dz, range], [r, g, b, cutoff]
        float range = lightExt.w;
        vec3 sourceDir = normalize(lightExt.xyz);
        float cutoff = lightColor.w;
        
        vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        lightDir = normalize(lightDir);
        
        float lightAngleDifference = max(dot(lightDir, sourceDir), 0.0);
        // this is very much hard-coding the cutoff radius but i dont really feel
        // like adding more shader attributes now
        float epsilon = (cos(acos(cutoff) * 0.75) - cutoff);
        float f = clamp((lightAngleDifference - cutoff) / epsilon, 0.0, 1.0);
        float att = f * pow(clamp((1. - dist * dist / (range * range)), 0., 1.0), 2.0);
        
        finalColor += att * lightColor * max(0.0, -dot(normal, lightDir));
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
    float f = clamp((dist - fogStart) / (fogEnd - fogStart) * fogStrength, 0.0, 1.0);
    baseColor.rgb = mix(baseColor.rgb, fogColor, f);
}
// include("fog.f.xsh")

uniform vec3 u_WireColor;
uniform float u_WireThickness;
varying vec4 v_barycentric;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

uniform vec3 u_WaterLevels;             // start, end, strength
uniform vec3 u_WaterColor;

void waterFog(inout vec4 baseColor) {
    float dist_to_camera = min(v_barycentric.w, 1.0);
    float dist_below = u_WaterLevels.y - v_vWorldPosition.z;
    float f = clamp(dist_below * dist_to_camera * u_WaterLevels.z / (u_WaterLevels.y - u_WaterLevels.x), 0.0, 1.0);
    baseColor.rgb = mix(baseColor.rgb, u_WaterColor, f);
}

void main() {
    vec4 color = vec4(texture2D(texColor, v_vWorldPosition.xy / terrainSize).rgb, 1) * texture2D(gm_BaseTexture, v_vWorldPosition.xy / terrainSize);
    
    CommonLight(color);
    CommonFog(color);
    waterFog(color);
    
    float r = mouseRadius;
    float dist = length(v_vWorldPosition.xy - mouse);
    float strength = clamp(-2.0 / (r * r) * (dist + r) * (dist - r), 0.0, 1.0);
    color = mix(color, cursorColor, strength);
    
    color.rgb = mix(color.rgb, u_WireColor, (1.0 - wireEdgeFactor(v_barycentric.xyz, u_WireThickness)) / v_barycentric.w);
    
    gl_FragColor = color;
}