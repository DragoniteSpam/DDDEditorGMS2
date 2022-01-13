// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vBarycentric;

uniform sampler2D displacementMap;
uniform float u_Displacement;
uniform vec2 u_Time;

#define ALPHA_REF 0.2
#define WIRE_ALPHA 0.5
#define WIRE_THICKNESS 1.0

uniform float u_Wireframe;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void main() {
    vec3 colorDM = texture2D(displacementMap, v_vTexcoord - vec2(mod(2.0 * u_Time.x / 10.0, 1.0), mod(-u_Time.y / 10.0, 1.0))).rgb;
    vec2 offset = vec2((colorDM.r + colorDM.g + colorDM.b) / 3.0 - 0.5) * u_Displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + vec2(mod(u_Time.x / 10.0, 1.0), mod(u_Time.y / 10.0, 1.0)) + offset) * v_vColour;
    
    gl_FragColor = finalColor;
}