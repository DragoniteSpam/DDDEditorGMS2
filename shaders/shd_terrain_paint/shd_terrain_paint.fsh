varying vec2 v_vTexcoord;
varying vec4 v_vColour;
// pretty standard passthrough shader, just here so that we can avoid funny
// business involving game maker's alpha testing and whatnot
void main() {
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
}