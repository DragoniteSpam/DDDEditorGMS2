varying vec2 v_vTexcoord;

uniform sampler2D samp_red;
uniform sampler2D samp_green;
uniform sampler2D samp_blue;

uniform vec3 u_SpriteDataR;
uniform vec3 u_SpriteDataG;
uniform vec3 u_SpriteDataB;

void main() {
    gl_FragColor.rgb = vec3(
        // the three samplers should all be grayscale images
        floor(texture2D(samp_red, v_vTexcoord * u_SpriteDataR.xy).r * u_SpriteDataR.z) / u_SpriteDataR.z,
        floor(texture2D(samp_green, v_vTexcoord * u_SpriteDataG.xy).r * u_SpriteDataG.z) / u_SpriteDataG.z,
        floor(texture2D(samp_blue, v_vTexcoord * u_SpriteDataB.xy).r * u_SpriteDataB.z) / u_SpriteDataB.z
    );
    gl_FragColor.a = 1.0;
}