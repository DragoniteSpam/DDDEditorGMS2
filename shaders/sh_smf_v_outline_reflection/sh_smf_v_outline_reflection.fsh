//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vShade;
varying vec3 v_vSpecular;
varying vec2 v_vReflectCoord;
varying float v_vReflectFactor;
varying float v_vRimLight;
varying float v_vOutline;

//Cel shading
uniform float celSteps;
//Outline
uniform vec3 outlineColour;
//Reflection map
uniform sampler2D reflectionSampler;
//Lights
uniform vec3 ambientColor;

void main()
{
	if (v_vOutline != 0.0)
	{
		gl_FragColor = vec4(outlineColour, 1.0);
	}
	else
	{
		vec4 baseCol = texture2D(gm_BaseTexture, v_vTexcoord);
		if (baseCol.a < 0.01){discard;}
	
		vec3 Shade = v_vShade;
		vec3 Specular = v_vSpecular;
		if (celSteps > 0.0)
		{
			Specular = floor(max(Specular, 0.0) * celSteps) / celSteps;
			Shade = ceil(max(Shade, 0.0) * celSteps - 0.5) / celSteps;
		}
	
	    gl_FragColor = vec4(Specular + v_vRimLight, 0.0) + vec4(ambientColor + Shade, 1.0) * baseCol;
	
		//Reflection
		if (v_vReflectFactor > 0.0)
		{
		    vec4 reflectCol = texture2D(reflectionSampler, v_vReflectCoord);
			gl_FragColor.rgb = mix(gl_FragColor.rgb, reflectCol.rgb, min(2.0 * v_vReflectFactor, 1.0) * (reflectCol.r+reflectCol.g+reflectCol.b) / 3.0);
			if (v_vReflectFactor > 0.5)
			{
				gl_FragColor.rgb = mix(gl_FragColor.rgb, reflectCol.rgb, 2.0 * v_vReflectFactor - 1.0);
			}
		}
	}
}

