varying vec2 v_vTexcoord;

uniform vec3 outline_color;

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(outline_color, ceil(clamp(max(abs(dFdx(base.a)), abs(dFdy(base.a))), 0.0, 1.0)));
}