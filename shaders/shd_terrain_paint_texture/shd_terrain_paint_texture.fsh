varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    gl_FragColor = v_vColour;
    if (texture2D(gm_BaseTexture, v_vTexcoord).a < 0.5) {
        discard;
    }
}