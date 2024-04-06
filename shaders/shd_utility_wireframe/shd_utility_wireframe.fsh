// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#define ALPHA_REF 0.2
#define WIRE_ALPHA 1.0

varying vec3 v_colour;
varying vec3 v_barycentric;

uniform vec4 u_WireColor;
uniform float u_WireThickness;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void main() {
    gl_FragColor = vec4(u_WireColor.rgb * v_colour, mix(1.0, 0.0, wireEdgeFactor(v_barycentric, u_WireThickness)));
    if (gl_FragColor.a < ALPHA_REF) discard;
}