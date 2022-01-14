#extension GL_OES_standard_derivatives : enable

varying float v_FragDistance;
varying vec4 v_WorldPosition;
varying vec3 v_Barycentric;
varying vec2 v_Texcoord;

uniform vec3 u_LightAmbientColor;
uniform vec3 u_LightDirection;

void CommonLight(inout vec4 baseColor) {
    vec3 normal = cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz));
    normal = normalize(normal * sign(normal.z));
    
    vec3 lightColor = u_LightAmbientColor;
    lightColor += u_LightAmbientColor * max(dot(normal, -normalize(u_LightDirection)), 0.0);
    
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
#define DATA_DEPTH                  3.0
#define DATA_BARYCENTRIC            4.0

uniform float u_OptViewData;

void main() {
    if (u_OptViewData == DATA_DIFFUSE) {
        vec2 worldTextureUV = v_WorldPosition.xy / u_TerrainSizeF;
        vec4 textureSamplerUV = texture2D(u_TexLookup, worldTextureUV);
        vec4 sampled = texture2D(gm_BaseTexture, textureSamplerUV.rg + v_Texcoord);
        vec4 color = vec4(texture2D(u_TexColor, worldTextureUV).rgb, 1) * sampled;
        
        CommonLight(color);
        CommonFog(color);
        WaterFog(color);
        
        float dist = length(v_WorldPosition.xy - u_Mouse);
        float strength = clamp(-2.0 / (u_MouseRadius * u_MouseRadius) * (dist + u_MouseRadius) * (dist - u_MouseRadius), 0.0, 1.0);
        color = mix(color, CURSOR_COLOR, strength);
        
        color.rgb = mix(color.rgb, u_WireColor, u_WireAlpha * (1.0 - wireEdgeFactor(v_Barycentric, u_WireThickness)) / (v_FragDistance / 128.0));
        
        gl_FragColor = color;
    } else if (u_OptViewData == DATA_POSITION) {
        gl_FragColor = vec4(v_WorldPosition.xyz / vec3(u_TerrainSizeF, 256), 1);
    } else if (u_OptViewData == DATA_NORMAL) {
        vec3 normal = cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz));
        normal = normalize(normal * sign(normal.z));
        gl_FragColor = vec4(normal * 0.5 + 0.5, 1);
    } else if (u_OptViewData == DATA_DEPTH) {
        float fd = v_FragDistance / 1000.0;
        gl_FragColor = vec4(fd, fd, fd, 1);
    } else if (u_OptViewData == DATA_BARYCENTRIC) {
        gl_FragColor = vec4(v_Barycentric, 1);
    } else {
        gl_FragColor = vec4(1);
    }
}