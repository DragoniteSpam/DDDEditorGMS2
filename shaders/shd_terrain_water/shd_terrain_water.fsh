varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vBarycentric;

uniform sampler2D displacementMap;
uniform float u_Displacement;
uniform float u_DisplacementScale;
uniform float u_Time;

void main() {
    vec3 colorDM = 2.0 * texture2D(displacementMap, v_vTexcoord * u_DisplacementScale - u_Time).rgb - 0.5;
    vec2 offset = colorDM.rg * u_Displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + offset) * v_vColour;
    
    gl_FragColor = finalColor;
}