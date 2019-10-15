//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vShade;
varying vec3 v_vSpecular;
varying float v_vRimLight;
varying vec4 v_vColour;

//Lights
uniform vec3 ambientColor;
//Cel shading
uniform float celSteps;

void main()
{
	vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
	if (baseCol.a < 0.01){discard;}
	
	vec3 Shade = v_vShade;
	vec3 Specular = v_vSpecular;
	if (celSteps > 0.0)
	{
		Specular = ceil(max(Specular, 0.0) * celSteps - 0.5) / celSteps;
		Shade = ceil(max(Shade, 0.0) * celSteps - 0.5) / celSteps;
	}
	
    gl_FragColor = vec4(Specular + v_vRimLight, 0.0) + vec4(ambientColor + Shade, 1.0) * v_vColour * baseCol;
}