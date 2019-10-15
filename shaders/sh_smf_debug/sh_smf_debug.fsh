//
// Simple passthrough fragment shader
//
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour;
}
