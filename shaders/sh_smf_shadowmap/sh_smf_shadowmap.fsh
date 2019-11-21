//
// Simple passthrough fragment shader
//
varying float v_vDepth;

void main()
{
    gl_FragColor.rgb = vec3(floor(v_vDepth * 255.0) / 255.0, fract(v_vDepth * 255.0), fract(v_vDepth * 255.0 * 255.0));
    gl_FragColor.a = 1.0;
}