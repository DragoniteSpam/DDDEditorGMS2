// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
varying float v_FragDistance;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vBarycentric;

#region lighting stuff
#pragma include("lighting.f.xsh")
/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 8
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

varying vec3 v_LightWorldNormal;
varying vec3 v_LightWorldPosition;

uniform vec3 lightAmbientColor;
uniform vec4 lightData[MAX_LIGHTS * 3];

void CommonLightEvaluate(int i, inout vec4 finalColor);
void CommonLight(inout vec4 baseColor);

void CommonLight(inout vec4 baseColor) {
    vec4 lightColor = vec4(lightAmbientColor, 1);
    
    CommonLightEvaluate(0, lightColor);
    CommonLightEvaluate(1, lightColor);
    CommonLightEvaluate(2, lightColor);
    CommonLightEvaluate(3, lightColor);
    CommonLightEvaluate(4, lightColor);
    CommonLightEvaluate(5, lightColor);
    CommonLightEvaluate(6, lightColor);
    CommonLightEvaluate(7, lightColor);
    
    baseColor *= clamp(lightColor, vec4(0), vec4(1));
}

void CommonLightEvaluate(int i, inout vec4 finalColor) {
    vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    vec4 lightExt = lightData[i * 3 + 1];
    vec4 lightColor = lightData[i * 3 + 2];
    
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        vec3 lightDir = -normalize(lightPosition);
        finalColor += clamp(lightColor * max(dot(v_LightWorldNormal, lightDir), 0.), 0.0, 1.0);
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        float att = pow(clamp((1. - dist * dist / (range * range)), 0., 1.), 2.);
        lightDir = normalize(lightDir);
        finalColor += clamp(lightColor * max(0., -dot(v_LightWorldNormal, lightDir)) * att, 0.0, 1.0);
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
        
        finalColor += clamp(att * lightColor * max(0., -dot(v_LightWorldNormal, lightDir)), 0.0, 1.0);
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
#endregion

#region Wireframe
uniform float u_WireDistance;
uniform vec3 u_WireColor;
uniform float u_WireAlpha;
uniform float u_WireThickness;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void DrawWireframe(inout vec4 color) {
    float factor = clamp((1.0 - wireEdgeFactor(v_vBarycentric, u_WireThickness)) / (v_FragDistance / u_WireDistance), 0.0, 1.0);
    color.rgb = mix(color.rgb, u_WireColor, u_WireAlpha * factor);
    color.a = mix(color.a, 1.0, u_WireAlpha * factor * 4.0);
}
#endregion

#region material stuff
uniform vec4 u_MaterialColor;
#endregion

// not sure why this works but gm_AlphaRefValue is not
#define ALPHA_REF 0.2
#define WIRE_ALPHA 1.0

void main() {
    vec4 diffuseColor = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 color = v_vColour * diffuseColor * u_MaterialColor;
    float sourceAlpha = color.a;
    
    CommonLight(color);
    CommonFog(color);
    
    gl_FragColor = vec4(color.rgb, sourceAlpha);
    
    if (u_WireAlpha > 0.0) {
        DrawWireframe(gl_FragColor);
    }
    
    if (gl_FragColor.a < ALPHA_REF) discard;
}