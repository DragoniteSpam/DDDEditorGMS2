varying vec2 v_vTexcoord;

#define samp_red gm_BaseTexture
uniform sampler2D samp_green;
uniform sampler2D samp_blue;

void main() {
    gl_FragColor.rgb = vec3(
        // the three samplers should all be grayscale images
        texture2D(samp_red, v_vTexcoord).r,
        texture2D(samp_green, v_vTexcoord).r,
        texture2D(samp_blue, v_vTexcoord).r
    );
    gl_FragColor.a = 1.0;
}