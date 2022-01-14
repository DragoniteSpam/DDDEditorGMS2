varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    if (gl_FragColor.a < 0.5) {
        discard;
    } else {
        gl_FragColor.a = 1.0;
    }
}