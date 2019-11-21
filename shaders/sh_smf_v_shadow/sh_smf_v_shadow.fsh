//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vShade;
varying vec3 v_vSpecular;
varying float v_vRimLight;
varying vec4 v_vColour;
varying vec4 v_vShadowCoord1;
varying vec4 v_vShadowCoord2;
varying float v_vShadowNormal;

//Lights
uniform vec3 ambientColor;
//Cel shading
uniform float celSteps;
//Shadows
uniform sampler2D shadowMap1;
uniform vec2 shadowClippingPlanes1;
uniform float shadowIntensity1;
uniform float shadowTexelSize1;
uniform vec3 shadowPos1;
uniform float shadowDepthBias1;
uniform sampler2D shadowMap2;
uniform vec2 shadowClippingPlanes2;
uniform float shadowIntensity2;
uniform float shadowTexelSize2;
uniform vec3 shadowPos2;
uniform float shadowDepthBias2;

uniform int shadowSmoothing;
uniform int shadowEnableCascade;

float slopeScaleDepthBias;

float colToDepth(vec3 c)
{
    return float((c.r) + (c.g / 255.0) + (c.b / (255.0 * 255.0)));
}

float readShadowmap(sampler2D Sampler, vec3 shadowCoord, float Texelsize, float Near, float Far)
{
    float depth = shadowCoord.z;
    float shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy).rgb);
    float shade = clamp(depth - shadowmapDepth, 0.0, 1.0);
    
    if (shadowSmoothing == 1)
    {
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, 0)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, 0)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, -Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        shade /= 5.0;
    }
    else if (shadowSmoothing == 2)
    {
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, 0)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, 0)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, -Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, -Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, -Texelsize)).rgb);
        shade += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        shade /= 9.0;
    }
    return clamp(1.0 - shade, 0.0, 1.0);
}

void main()
{    
    vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
    if (baseCol.a < 0.01){discard;}
    vec3 Shade = v_vShade;
    vec3 Specular = v_vSpecular;
    
    //Shadowmap 1
    vec3 shadowCoord = vec3(0.5 + v_vShadowCoord1.x / v_vShadowCoord1.w, 0.5 - v_vShadowCoord1.y / v_vShadowCoord1.w, v_vShadowCoord1.z);
    if (shadowCoord.x > shadowTexelSize1 && shadowCoord.x < 1.0-shadowTexelSize1 * 2.0 && shadowCoord.y > shadowTexelSize1 && shadowCoord.y < 1.0-shadowTexelSize1 * 2.0)
    {
        slopeScaleDepthBias = shadowTexelSize1 * tan(acos(v_vShadowNormal));
        shadowCoord.z += slopeScaleDepthBias - shadowDepthBias1;
        Shade -= min(v_vShadowNormal, 0.0) * shadowIntensity1 * readShadowmap(shadowMap1, shadowCoord, shadowTexelSize1, shadowClippingPlanes1[0], shadowClippingPlanes1[1]);    
    }
    //Shadowmap 2
    else if (shadowEnableCascade == 1)
    {
        shadowCoord = vec3(0.5 + v_vShadowCoord2.x / v_vShadowCoord2.w, 0.5 - v_vShadowCoord2.y / v_vShadowCoord2.w, v_vShadowCoord2.z);
        if (shadowCoord.x > shadowTexelSize2 && shadowCoord.x < 1.0-shadowTexelSize2 && shadowCoord.y > shadowTexelSize2 && shadowCoord.y < 1.0-shadowTexelSize2)
        {
            slopeScaleDepthBias = shadowTexelSize2 * tan(acos(v_vShadowNormal));
            shadowCoord.z += slopeScaleDepthBias - shadowDepthBias2;
            Shade -= min(v_vShadowNormal, 0.0) * shadowIntensity2 * readShadowmap(shadowMap2, shadowCoord, shadowTexelSize2, shadowClippingPlanes2[0], shadowClippingPlanes2[1]);    
        }
    }
    
    if (celSteps > 0.0)
    {
        Specular = ceil(max(Specular, 0.0) * celSteps - 0.5) / celSteps;
        Shade = ceil(max(Shade, 0.0) * celSteps - 0.5) / celSteps;
    }
    
    gl_FragColor = vec4(Specular + v_vRimLight, 0.0) + vec4(ambientColor + Shade, 1.0) * v_vColour * baseCol;
}