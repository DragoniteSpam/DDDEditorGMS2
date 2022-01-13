// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vBarycentric;

uniform sampler2D displacementMap;
uniform float u_Displacement;
uniform float u_Time;

#define ALPHA_REF 0.2
#define WIRE_ALPHA 0.5
#define WIRE_THICKNESS 1.0

uniform float u_Wireframe;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void main() {
    vec3 colorDM = 2.0 * texture2D(displacementMap, v_vTexcoord - u_Time).rgb - 0.5;
    vec2 offset = colorDM.rg * u_Displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + offset) * v_vColour;
    
    gl_FragColor = finalColor;
}