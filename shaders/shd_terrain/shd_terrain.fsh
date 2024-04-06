varying float v_FragDistance;
varying vec4 v_WorldPosition;
varying vec3 v_Barycentric;
varying vec2 v_Texcoord;

uniform vec3 u_LightAmbientColor;
uniform vec4 u_LightDirection;
uniform vec4 u_LightDirectionSecondary;
uniform sampler2D s_ShadingGradient;

uniform float u_FogStrength;
uniform float u_FogStart;
uniform float u_FogEnd;
uniform vec3 u_FogColor;

void CommonFog(inout vec4 baseColor) {
    float f = clamp((v_FragDistance - u_FogStart) / (u_FogEnd - u_FogStart) * u_FogStrength, 0.0, 1.0);
    baseColor.rgb = mix(baseColor.rgb, u_FogColor, f);
}

uniform vec3 u_WaterLevels;             // end, start, strength
uniform vec3 u_WaterColor;

void WaterFog(inout vec4 baseColor) {
    float dist_to_camera = min(v_FragDistance, 4.0);                            // ensure that there will always be a little visibility if you're right in front of something
    float dist_below = u_WaterLevels.y - v_WorldPosition.z;
    float fdepth = clamp(dist_below * dist_to_camera / (u_WaterLevels.y - u_WaterLevels.x), 0.0, 1.0) * u_WaterLevels.z;
    float fdistance = clamp(sign(dist_below) * v_FragDistance / 2048.0, 0.0, 1.0) * u_WaterLevels.z;
    baseColor.rgb = mix(baseColor.rgb, u_WaterColor, max(fdepth, fdistance));
}

uniform sampler2D u_TexLookup;
uniform sampler2D u_TexColor;

uniform vec2 u_TerrainSizeF;

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

#region Cursor
const vec3 CURSOR_COLOR = vec3(0.6, 0, 0);

uniform vec4 u_Mouse;           // x, y, radius, strength
uniform sampler2D u_CursorTexture;

void DrawCursor(inout vec3 base, vec2 position) {
    vec2 cursorStart = u_Mouse.xy - u_Mouse.z;
    vec2 cursorEnd = u_Mouse.xy + u_Mouse.z;
    vec2 cursorUVSource = (position - cursorStart) / (cursorEnd - cursorStart);
    vec2 cursorUV = clamp((position - cursorStart) / (cursorEnd - cursorStart), vec2(0), vec2(1));
    vec4 cursorSample = texture2D(u_CursorTexture, cursorUV);
    float cursorDiff = 1.0 - min(ceil(distance(cursorUV, cursorUVSource)), 1.0);
    base = mix(base, CURSOR_COLOR, cursorSample.r * cursorSample.a * u_Mouse.w * cursorDiff);
}
#endregion

#region Wireframe
uniform float u_WireThickness;
uniform float u_WireDistance;
uniform vec3 u_WireColor;
uniform float u_WireAlpha;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void DrawWireframe(inout vec4 color) {
    float factor = (1.0 - wireEdgeFactor(v_Barycentric, u_WireThickness)) / (v_FragDistance / u_WireDistance);
    color.rgb = mix(color.rgb, u_WireColor, u_WireAlpha * factor);
    color.a = mix(color.a, 1.0, u_WireAlpha * factor * 4.0);
}
#endregion

#region Highlighting upwards faces
uniform float u_HightlightThreshold;

const vec3 up = vec3(0, 0, 1);

float Dither2x2(vec2 position) {
    int x = int(min(mod(position.x, 6.0), 2.0));
    int y = int(min(mod(position.y, 6.0), 2.0));
    int index = x + y * 2;
    float limit = 0.0;
    
    if (x < 8) {
        if (index == 0) limit = 0.25;
        if (index == 1) limit = 0.75;
        if (index == 2) limit = 1.00;
        if (index == 3) limit = 0.50;
    }
    
    return limit;
}

void DrawUpwardHightlightDither(inout vec3 base, in vec3 norm) {
    if (dot(norm, up) > u_HightlightThreshold) {
        // the dither effect is just an inverse color
        base.rgb = mix(base.rgb, vec3(1) - base.rgb, Dither2x2(gl_FragCoord.xy));
    }
}
#endregion

void main() {
    vec3 normal = normalize(cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz)));
    float NdotL = clamp(dot(normal, u_LightDirection.xyz) * u_LightDirection.w, 0.0, 1.0);
    NdotL = texture2D(s_ShadingGradient, vec2(NdotL, 0)).r;
    float NdotLSecondary = clamp(dot(normal, u_LightDirectionSecondary.xyz) * u_LightDirectionSecondary.w, 0.0, 1.0);
    
    if (u_OptViewData == DATA_DIFFUSE) {
        vec2 worldTextureUV = v_WorldPosition.xy / u_TerrainSizeF;
        vec4 textureSamplerUV = texture2D(u_TexLookup, worldTextureUV);
        vec4 sampled = texture2D(gm_BaseTexture, textureSamplerUV.rg + v_Texcoord);
        vec4 color = vec4(texture2D(u_TexColor, worldTextureUV).rgb, 1) * sampled;
        
        vec3 accumulatedColor = u_LightAmbientColor + (max(0.0, NdotL) + max(0.0, NdotLSecondary));
        color.rgb *= accumulatedColor;
        
        CommonFog(color);
        WaterFog(color);
        
        gl_FragColor = color;
    } else if (u_OptViewData == DATA_POSITION) {
        gl_FragColor = vec4(v_WorldPosition.xyz / vec3(u_TerrainSizeF, 256), 1);
    } else if (u_OptViewData == DATA_NORMAL) {
        vec3 snormal = normalize(normal * sign(normal.z));
        gl_FragColor = vec4(snormal * 0.5 + 0.5, 1);
    } else if (u_OptViewData == DATA_HEIGHT) {
        float max_height = 256.0;
        float fd = max(min(v_WorldPosition.z / max_height, 1.0), 0.0);
        gl_FragColor = vec4(fd, fd, fd, 1);
    } else if (u_OptViewData == DATA_BARYCENTRIC) {
        gl_FragColor = vec4(v_Barycentric, 1);
    } else {
        gl_FragColor = vec4(1);
    }
    
    /*if (u_LightShadows == 1.0) {
        float depthValue = fromDepthColor(texture2D(s_DepthTexture, v_ShadowTexcoord));
        float depth_bias = 0.005 * tan(acos(NdotL));
        if (v_LightDistance > depthValue + depth_bias) {
            gl_FragColor.rgb *= u_LightAmbientColor;
        }
    }*/
    
    DrawCursor(gl_FragColor.rgb, v_WorldPosition.xy);
    
    if (u_HightlightThreshold > 0.0) {
        DrawUpwardHightlightDither(gl_FragColor.rgb, normal);
    }
    
    if (u_WireAlpha > 0.0) {
        DrawWireframe(gl_FragColor);
    }
}