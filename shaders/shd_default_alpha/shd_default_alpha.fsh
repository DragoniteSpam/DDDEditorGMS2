varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float alpha;

void main() {
    vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(base.rgb, base.a * alpha);
}