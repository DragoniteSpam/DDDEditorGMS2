varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float buckets;

void main() {
    vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(floor(base.r * buckets) / buckets,
        floor(base.g * buckets) / buckets,
        floor(base.b * buckets) / buckets,
    1.);
}