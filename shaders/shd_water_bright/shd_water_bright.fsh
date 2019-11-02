varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D displacementMap;
uniform float displacement;
uniform vec2 time;

void main() {
    vec4 colorDM = texture2D(displacementMap, v_vTexcoord - vec2(mod(2. * time.x / 10., 1.), mod(-time.y / 10., 1.)));
    vec2 offset = vec2((colorDM.r + colorDM.g + colorDM.b) / 3. - 0.5) * displacement;
    vec4 finalColor = texture2D(gm_BaseTexture, v_vTexcoord + vec2(mod(time.x / 10., 1.), mod(time.y / 10., 1.)) + offset);
    finalColor.a = clamp(length(finalColor.rgb) / 2., 0., 1.);
    gl_FragColor = finalColor;
}