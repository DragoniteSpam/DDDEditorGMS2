varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define f 8.

void main() {
    vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(floor(base.r * f) / f,
        floor(base.g * f) / f,
        floor(base.b * f) / f,
    1.);
}