varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float buckets;

void main() {
    vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    if (buckets == 0.0) {
        gl_FragColor = base;
    } else {
        gl_FragColor = floor(base * buckets) / buckets;
    }
}