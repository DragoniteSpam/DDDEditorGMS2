varying vec2 v_vTexcoord;

uniform sampler2D samp_red;
uniform sampler2D samp_green;
uniform sampler2D samp_blue;

uniform vec2 u_SpriteScaleR;
uniform vec2 u_SpriteScaleG;
uniform vec2 u_SpriteScaleB;

void main() {
    gl_FragColor.rgb = vec3(
        // the three samplers should all be grayscale images
        texture2D(samp_red, v_vTexcoord * u_SpriteScaleR).r,
        texture2D(samp_green, v_vTexcoord * u_SpriteScaleG).r,
        texture2D(samp_blue, v_vTexcoord * u_SpriteScaleB).r
    );
    gl_FragColor.a = 1.0;
}