uniform vec3 col;

void main() {
    gl_FragColor = vec4(vec3(col), 1);
}