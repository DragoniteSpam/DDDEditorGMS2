/// https://github.com/GameMakerDiscord/Xpanda

#define MAX_LIGHTS 16
#define LIGHT_DIRECTIONAL 1.
#define LIGHT_POINT 2.
#define LIGHT_SPOT 3.

varying Vec3 v_LightWorldNormal;
varying Vec3 v_LightWorldPosition;
varying vec3 v_EyeNormal;
varying vec3 v_Eye;
varying vec2 v_UV;

uniform sampler2D normalMap;

uniform float lightBuckets;
uniform Vec3 lightAmbientColor;
uniform Vec4 lightData[MAX_LIGHTS * 3];
uniform Vec3 lightDayTimeColor;
uniform Vec3 lightWeatherColor;

void CommonLightEvaluate(int i, inout Vec4 finalColor);
void CommonLight(inout Vec4 baseColor);
Vec3 GetTangentSpaceNormal();

void CommonLight(inout Vec4 baseColor) {
    Vec4 lightColor = Vec4(lightAmbientColor * lightDayTimeColor * lightWeatherColor, 1.);
    
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
    
    baseColor *= clamp(lightColor, Vec4(0.), Vec4(1.));
}

void CommonLightEvaluate(int i, inout Vec4 finalColor) {
    Vec3 lightPosition = lightData[i * 3].xyz;
    float type = lightData[i * 3].w;
    Vec4 lightExt = lightData[i * 3 + 1];
    Vec4 lightColor = lightData[i * 3 + 2];
    
    if (type == LIGHT_DIRECTIONAL) {
        // directional light: [x, y, z, type], [0, 0, 0, 0], [r, g, b, 0]
        Vec3 lightDir = -normalize(lightPosition);
        finalColor += lightColor * max(dot(v_LightWorldNormal, lightDir), 0.);
    } else if (type == LIGHT_POINT) {
        float range = lightExt.w;
        // point light: [x, y, z, type], [0, 0, 0, range], [r, g, b, 0]
        Vec3 lightDir = v_LightWorldPosition - lightPosition;
        float dist = length(lightDir);
        float att = pow(clamp((1. - dist * dist / (range * range)), 0., 1.), 2.);
        lightDir = normalize(lightDir);
        finalColor += lightColor * max(0., -dot(v_LightWorldNormal, lightDir)) * att;
    } else if (type == LIGHT_SPOT) {
        // spot light: [x, y, z, type], [dx, dy, dz, range], [r, g, b, cutoff]
        float range = lightExt.w;
        Vec3 sourceDir = normalize(lightExt.xyz);
        float cutoff = lightColor.w;
        
        Vec3 lightDir = v_LightWorldPosition - lightPosition;
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

Vec3 GetTangentSpaceNormal() {
    // get edge vectors of the pixel triangle
    Vec3 dp1 = DDX(v_Eye);
    Vec3 dp2 = DDY(v_Eye);
    Vec2 duv1 = DDX(v_UV);
    Vec2 duv2 = DDY(v_UV);
    
    // solve the linear system
    Vec3 dp2perp = cross(dp2, v_EyeNormal);
    Vec3 dp1perp = cross(v_EyeNormal, dp1);
    Vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    Vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
    
    // construct a scale-invariant frame 
    float invmax = 1.0 / sqrt(max(dot(T, T), dot(B, B)));
    Mat4 tbn = Mat3(normalize(T * invmax), normalize(B * invmax), v_EyeNormal);
	
	return normalize(tbn * (Texture(normalMap, v_UV).rgb * 2.0 - 1.0));
}