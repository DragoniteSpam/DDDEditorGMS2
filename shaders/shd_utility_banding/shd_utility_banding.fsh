varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_Bands;

void main() {
    gl_FragColor = floor((v_vColour * texture2D(gm_BaseTexture, v_vTexcoord)) * u_Bands) / u_Bands;
}