varying vec4 v_WorldPosition;

void main() {
    vec3 normal = normalize(cross(dFdx(v_WorldPosition.xyz), dFdy(v_WorldPosition.xyz)));
    gl_FragColor = vec4(normal * 0.5 + 0.5, 1);
}