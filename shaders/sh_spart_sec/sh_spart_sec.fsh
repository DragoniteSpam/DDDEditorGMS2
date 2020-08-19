/*/
    This is a shader made for use with the sPart system.
    
    Sindre Hauge Larsen, 2019
    www.TheSnidr.com
/*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_PtAlphaTestRef;

void main()
{
    vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
    if (baseCol.a < u_PtAlphaTestRef){discard;}
    gl_FragColor = v_vColour * baseCol;
}