//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);
    if (gl_FragColor.a < 0.01){discard;}
}