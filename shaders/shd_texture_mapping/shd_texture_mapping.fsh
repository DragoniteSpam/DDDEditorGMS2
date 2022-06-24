// https://web.archive.org/web/20200306081453/http://codeflow.org/entries/2012/aug/02/easy-wireframe-display-with-barycentric-coordinates/
#extension GL_OES_standard_derivatives : enable

varying vec3 v_vBarycentric;

#region Wireframe
uniform float u_WireDistance;
uniform vec3 u_WireColor;
uniform float u_WireAlpha;
uniform float u_WireThickness;

float wireEdgeFactor(vec3 barycentric, float thickness) {
    vec3 a3 = smoothstep(vec3(0), fwidth(barycentric) * thickness, barycentric);
    return min(min(a3.x, a3.y), a3.z);
}
#endregion

void main() {
    if (u_WireAlpha > 0.0) {
         gl_FragColor = vec4(u_WireColor, 1.0 - wireEdgeFactor(v_vBarycentric, u_WireThickness));
    } else {
        gl_FragColor = vec4(u_WireColor, 1.0);
    }
}