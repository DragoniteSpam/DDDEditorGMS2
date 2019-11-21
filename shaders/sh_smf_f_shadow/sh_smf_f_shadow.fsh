//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vEyeVec;
varying vec3 v_vNormal;
varying vec3 v_vPos;
varying vec4 v_vShadowCoord1;
varying vec4 v_vShadowCoord2;
varying float v_vShadowNormal1;
varying float v_vShadowNormal2;

//Lights
const int MAXLIGHTS = 8;
uniform vec4 lightArray[MAXLIGHTS];
uniform int lightNum;
uniform vec3 ambientColor;
//Specular lighting
uniform float reflectivity;
uniform float damping;
//Cel shading
uniform float celSteps;
//Rim lighting
uniform float rimPower;
uniform float rimFactor;
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

float colToDepth(vec3 c)
{
    return float((c.r) + (c.g / 255.0) + (c.b / (255.0 * 255.0)));
}

float readShadowmap(sampler2D Sampler, vec3 shadowCoord, float Texelsize, float Near, float Far)
{
    float depth = shadowCoord.z;// - 1.0;
    float shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy).rgb);
    float visibility = clamp(depth - shadowmapDepth, 0.0, 1.0);
    
    if (shadowSmoothing == 1)
    {
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, 0)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, 0)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, -Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        visibility /= 5.0;
    }
    else if (shadowSmoothing == 2)
    {
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, 0)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, 0)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(0, -Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(Texelsize, -Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        shadowmapDepth = Near + (Far-Near) * colToDepth(texture2D(Sampler, shadowCoord.xy + vec2(-Texelsize, -Texelsize)).rgb);
        visibility += clamp(depth - shadowmapDepth, -1.0, 1.0);
        
        visibility /= 9.0;
    }
    //if (visibility < 0.4){visibility = 0.0;}
    return clamp(1.0 - visibility, 0.0, 1.0);
}

void main()
{
    vec2 TexCoord = v_vTexcoord;
    vec3 eyeVec = normalize(v_vEyeVec);
    vec3 NewNormal = normalize(v_vNormal);
    vec3 Specular = vec3(0.0);
    vec3 Shade = vec3(0.0);
    float att = 1.0;
    for (int i = 0; i < MAXLIGHTS; i ++)
    {
        if (i >= lightNum){break;}
        vec3 lightDir;
        vec3 lightCol = vec3(1.0, 1.0, 1.0);
        //Point light
        if (lightArray[i*2].w > 0.0)
        {
            vec3 lightPos = lightArray[i*2].xyz;
            lightDir = v_vPos - lightPos;
            float dist = length(lightDir);
            lightDir /= dist;
            att = clamp((1.0 - dist*dist / (lightArray[i*2].w * lightArray[i*2].w)), 0.0, 1.0);
            att *= att;
            lightCol = lightArray[i*2+1].w * lightArray[i*2+1].rgb;
        }
        //Directional light
        else if (lightArray[i*2].w == 0.0)
        {
            lightDir = lightArray[i*2].xyz;
            lightCol = lightArray[i*2+1].w * lightArray[i*2+1].rgb;
        }
        //Cone light
        else
        {
            vec3 lightPos = lightArray[i*2].xyz;
            lightDir = v_vPos - lightPos;
            att = 0.0;
            float dist = length(lightDir);
            lightDir /= dist;
            if (dot(lightDir, lightArray[i*2+1].xyz) > lightArray[i*2+1].w)
            {
                att = clamp((1.0 - dist*dist / (lightArray[i*2].w * lightArray[i*2].w)), 0.0, 1.0);
                att *= clamp(0.0, 1.0, 4.0 * (dot(lightDir, lightArray[i*2+1].xyz) - lightArray[i*2+1].w) / (1.0-lightArray[i*2+1].w));
            }
            else
            {
                lightCol = vec3(0.0);
            }
        }
        
        //Diffuse
        Shade += lightCol * max(- dot(NewNormal, lightDir), 0.0) * att;
        
        //Specular lighting
        if (damping > 0.0 && reflectivity > 0.0)
        {
            vec3 reflectedLight = reflect(lightDir, NewNormal);
            float specFactor = max(dot(reflectedLight, eyeVec), 0.0);
            float dampFactor = pow(specFactor, damping);
            Specular += lightCol * dampFactor * reflectivity * att;
        }
    }
    att = 1.0;
    //Shadowmap 1
    vec3 lightDir = normalize(v_vPos - shadowPos1);
    float slopeScaleDepthBias = shadowTexelSize1 * tan(acos(v_vShadowNormal1));
    vec3 shadowCoord = vec3(0.5 + v_vShadowCoord1.x / v_vShadowCoord1.w, 0.5 - v_vShadowCoord1.y / v_vShadowCoord1.w, v_vShadowCoord1.z + slopeScaleDepthBias - shadowDepthBias1);
    if (shadowCoord.x > shadowTexelSize1 && shadowCoord.x < 1.0-shadowTexelSize1 * 2.0 && shadowCoord.y > shadowTexelSize1 && shadowCoord.y < 1.0-shadowTexelSize1 * 2.0)
    {
        att = shadowIntensity1 * readShadowmap(shadowMap1, shadowCoord, shadowTexelSize1, shadowClippingPlanes1[0], shadowClippingPlanes1[1]);    
    }
    //Shadowmap 2
    else if (shadowEnableCascade == 1)
    {
        slopeScaleDepthBias = shadowTexelSize2 * tan(acos(v_vShadowNormal2));
        shadowCoord = vec3(0.5 + v_vShadowCoord2.x / v_vShadowCoord2.w, 0.5 - v_vShadowCoord2.y / v_vShadowCoord2.w, v_vShadowCoord2.z + slopeScaleDepthBias - shadowDepthBias2);
        if (shadowCoord.x > shadowTexelSize2 && shadowCoord.x < 1.0-shadowTexelSize2 && shadowCoord.y > shadowTexelSize2 && shadowCoord.y < 1.0-shadowTexelSize2)
        {
            vec3 lightDir = normalize(v_vPos - shadowPos2);
            att = shadowIntensity2 * readShadowmap(shadowMap2, shadowCoord, shadowTexelSize2, shadowClippingPlanes2[0], shadowClippingPlanes2[1]);    
        }
    }
    //Diffuse
    Shade += max(- dot(NewNormal, lightDir), 0.0) * att;
    //Specular lighting
    if (damping > 0.0 && reflectivity > 0.0){
        vec3 reflectedLight = reflect(lightDir, NewNormal);
        float specFactor = max(dot(reflectedLight, eyeVec), 0.0);
        float dampFactor = pow(specFactor, damping);
        Specular += dampFactor * reflectivity * att;}
    
    //Cel shading
    if (celSteps > 0.0)
    {
        Specular = floor(max(Specular, 0.0) * celSteps) / celSteps;
        Shade = ceil(max(Shade, 0.0) * celSteps - 0.5) / celSteps;
    }
    
    //Rim lighting
    float RimLight = 0.0;
    if (rimPower > 0.0 && rimFactor > 0.0)
    {
        RimLight = rimFactor * pow(1.0 - max(dot(eyeVec, NewNormal), 0.0), rimPower);
    }
    
    vec4 baseCol = texture2D(gm_BaseTexture, TexCoord);
    if (baseCol.a < 0.01){discard;}
    gl_FragColor = vec4(Specular + RimLight, 0.0) + vec4(ambientColor + Shade, 1.0) * baseCol;
}