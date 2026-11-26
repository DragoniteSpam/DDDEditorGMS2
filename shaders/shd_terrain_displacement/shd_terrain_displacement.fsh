varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_slope;
uniform float u_offset;

void main() {
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord) * vec4(vec3(u_slope), 1) + vec4(vec3(u_offset), 0);
}