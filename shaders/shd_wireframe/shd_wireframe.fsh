// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#extension GL_OES_standard_derivatives : enable

varying vec3 v_barycentric;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}

void main() {
    gl_FragColor = mix(vec4(1), vec4(0), wireEdgeFactor(v_barycentric, 3.0));
}