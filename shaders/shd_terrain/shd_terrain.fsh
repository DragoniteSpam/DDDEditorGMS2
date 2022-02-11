#extension GL_OES_standard_derivatives : enable

varying float v_FragDistance;
varying vec4 v_WorldPosition;
varying vec3 v_Barycentric;
varying vec2 v_Texcoord;

uniform vec3 u_LightAmbientColor;
uniform vec3 u_LightDirection;
uniform sampler2D s_ShadingGradient;

void CommonLight(inout vec4 baseColor, float NdotL) {
    vec3 lightColor = u_LightAmbientColor;
    lightColor += u_LightAmbientColor * NdotL;
    
    baseColor.rgb *= clamp(lightColor, vec3(0), vec3(1));
}

uniform float u_FogStrength;
uniform float u_FogStart;
uniform float u_FogEnd;
uniform vec3 u_FogColor;

void CommonFog(inout vec4 baseColor) {
    float f = clamp((v_FragDistance - u_FogStart) / (u_FogEnd - u_FogStart) * u_FogStrength, 0.0, 1.0);
    baseColor.rgb = mix(baseColor.rgb, u_FogColor, f);
}

uniform vec3 u_WireColor;
uniform float u_WireThickness;
uniform float u_WireAlpha;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

uniform vec3 u_WaterLevels;             // start, end, strength
uniform vec3 u_WaterColor;

void WaterFog(inout vec4 baseColor) {
    float dist_to_camera = min(v_FragDistance, 1.0);
    float dist_below = u_WaterLevels.y - v_WorldPosition.z;
    float f = clamp(dist_below * dist_to_camera * u_WaterLevels.z / (u_WaterLevels.y - u_WaterLevels.x), 0.0, 1.0);
    baseColor.rgb = mix(baseColor.rgb, u_WaterColor, f);
}

uniform sampler2D u_TexLookup;
uniform sampler2D u_TexColor;

uniform vec2 u_TerrainSizeF;

uniform vec2 u_Mouse;
uniform float u_MouseRadius;

const vec4 CURSOR_COLOR = vec4(0.6, 0, 0, 1);

#define DATA_DIFFUSE                0.0
#define DATA_POSITION               1.0
#define DATA_NORMAL                 2.0
#define DATA_HEIGHT                 3.0
#define DATA_BARYCENTRIC            4.0

uniform float u_OptViewData;

uniform sampler2D s_DepthTexture;
uniform float u_LightShadows;

varying float v_LightDistance;
varying vec2 v_ShadowTexcoord;

const vec3 UNDO = vec3(1.0, 256.0, 65536.0) / 16777215.0 * 255.0;
float fromDepthColor(vec4 color) {
    return dot(color.rgb, UNDO) + color.a;
}

void main() {
    vec3 normal = normalize(cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz)));
    float NdotL = clamp(dot(normal, -normalize(u_LightDirection)), 0.0, 1.0);
    NdotL = texture2D(s_ShadingGradient, vec2(NdotL, 0)).r;
    
    if (u_OptViewData == DATA_DIFFUSE) {
        vec2 worldTextureUV = v_WorldPosition.xy / u_TerrainSizeF;
        vec4 textureSamplerUV = texture2D(u_TexLookup, worldTextureUV);
        vec4 sampled = texture2D(gm_BaseTexture, textureSamplerUV.rg + v_Texcoord);
        vec4 color = vec4(texture2D(u_TexColor, worldTextureUV).rgb, 1) * sampled;
        
        CommonLight(color, NdotL);
        CommonFog(color);
        WaterFog(color);
        
        gl_FragColor = color;
    } else if (u_OptViewData == DATA_POSITION) {
        gl_FragColor = vec4(v_WorldPosition.xyz / vec3(u_TerrainSizeF, 256), 1);
    } else if (u_OptViewData == DATA_NORMAL) {
        vec3 normal = cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz));
        normal = normalize(normal * sign(normal.z));
        gl_FragColor = vec4(normal * 0.5 + 0.5, 1);
    } else if (u_OptViewData == DATA_HEIGHT) {
        float max_height = 256.0;
        float fd = max(min(v_WorldPosition.z / max_height, 1.0), 0.0);
        gl_FragColor = vec4(fd, fd, fd, 1);
    } else if (u_OptViewData == DATA_BARYCENTRIC) {
        gl_FragColor = vec4(v_Barycentric, 1);
    } else {
        gl_FragColor = vec4(1);
    }
    
    if (u_LightShadows == 1.0) {
        float depthValue = fromDepthColor(texture2D(s_DepthTexture, v_ShadowTexcoord));
        float depth_bias = 0.005 * tan(acos(NdotL));
        if (v_LightDistance > depthValue + depth_bias) {
            gl_FragColor.rgb *= u_LightAmbientColor;
        }
    }
    
    float dist = length(v_WorldPosition.xy - u_Mouse);
    float strength = clamp(-2.0 / (u_MouseRadius * u_MouseRadius) * (dist + u_MouseRadius) * (dist - u_MouseRadius), 0.0, 1.0);
    gl_FragColor = mix(gl_FragColor, CURSOR_COLOR, strength / 3.0);
    
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_WireColor, u_WireAlpha * (1.0 - wireEdgeFactor(v_Barycentric, u_WireThickness)) / (v_FragDistance / 128.0));
}