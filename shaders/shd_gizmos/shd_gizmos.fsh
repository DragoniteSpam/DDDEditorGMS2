varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_override_color;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_override_color.rgb, u_override_color.a);
}
