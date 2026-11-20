uniform vec3 u_color;

void main()
{
    gl_FragColor.rgb = u_color;
    gl_FragColor.a = 1.0;
}
