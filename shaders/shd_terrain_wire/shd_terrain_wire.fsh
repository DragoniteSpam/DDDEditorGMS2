// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#extension GL_OES_standard_derivatives : enable

varying vec3 v_barycentric;

float edgeFactor(float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(v_barycentric) * thickness, v_barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void main() {
    // much better
    gl_FragColor = mix(vec4(1), vec4(0), edgeFactor(3.0));
}