//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vNormal;
varying vec3 v_vEyeVec;
varying vec3 v_vPos;

//Reflection map
uniform sampler2D reflectionSampler;
uniform float reflectionFactor;
//Lights
const int MAXLIGHTS = 8;
uniform vec4 lightArray[MAXLIGHTS];
uniform int lightNum;
uniform vec3 ambientColor;
//Specular
uniform float reflectivity;
uniform float damping;
//Cel shading
uniform float celSteps;
//Rim lighting
uniform float rimPower;
uniform float rimFactor;
//Texture UVs
uniform vec4 refUVs;

void main()
{
	vec2 TexCoord = v_vTexcoord;
	vec3 eyeVec = normalize(v_vEyeVec);
	vec3 NewNormal = normalize(v_vNormal);
	
	//Lighting
    vec3 Specular = vec3(0.0);
	vec3 Shade = vec3(0.0);
	for (int i = 0; i < MAXLIGHTS; i ++)
	{
		if (i >= lightNum){break;}
		vec3 lightDir;
		float att = 1.0;
		vec3 lightCol = vec3(1.0, 1.0, 1.0);
		//Point light
		if (lightArray[i*2].w > 0.0)
		{
			vec3 lightPos = lightArray[i*2].xyz;
			lightDir = v_vPos - lightPos;
			float dist = length(lightDir);
			lightDir /= dist;
			att = clamp((1.0 - dist*dist / (lightArray[i*2].w * lightArray[i*2].w)), 0.0, 1.0);
			att *= att;
			lightCol = lightArray[i*2+1].w * lightArray[i*2+1].rgb;
		}
		//Directional light
		else if (lightArray[i*2].w == 0.0)
		{
			lightDir = lightArray[i*2].xyz;
			lightCol = lightArray[i*2+1].w * lightArray[i*2+1].rgb;
		}
		//Cone light
		else
		{
			vec3 lightPos = lightArray[i*2].xyz;
			lightDir = v_vPos - lightPos;
			att = 0.0;
			float dist = length(lightDir);
			lightDir /= dist;
			if (dot(lightDir, lightArray[i*2+1].xyz) > lightArray[i*2+1].w)
			{
				att = clamp((1.0 - dist*dist / (lightArray[i*2].w * lightArray[i*2].w)), 0.0, 1.0);
				att *= clamp(0.0, 1.0, 4.0 * (dot(lightDir, lightArray[i*2+1].xyz) - lightArray[i*2+1].w) / (1.0-lightArray[i*2+1].w));
			}
			else
			{
				lightCol = vec3(0.0);
			}
		}
		
		//Diffuse
		Shade += lightCol * max(- dot(NewNormal, lightDir), 0.0) * att;
		
	    //Specular lighting
		if (damping > 0.0 && reflectivity > 0.0)
		{
		    vec3 reflectedLight = reflect(lightDir, NewNormal);
		    float specFactor = max(dot(reflectedLight, eyeVec), 0.0);
		    float dampFactor = pow(specFactor, damping);
		    Specular += lightCol * dampFactor * reflectivity * att;
		}
	}
	
	//Cel shading
	if (celSteps > 0.0)
	{
		Specular = floor(max(Specular, 0.0) * celSteps) / celSteps;
		Shade = ceil(max(Shade, 0.0) * celSteps - 0.5) / celSteps;
	}
	
	//Rim lighting
	float RimLight = 0.0;
	if (rimPower > 0.0 && rimFactor > 0.0)
	{
		RimLight = rimFactor * pow(1.0 - max(dot(eyeVec, NewNormal), 0.0), rimPower);
	}
	
	vec4 baseCol = texture2D(gm_BaseTexture, TexCoord);
	if (baseCol.a < 0.01){discard;}
    gl_FragColor.rgb = Specular + RimLight + (Shade + ambientColor) * baseCol.rgb;
	gl_FragColor.a = baseCol.a;
	
	//Reflection
	if (reflectionFactor > 0.0)
	{
		vec3 reflection = normalize(reflect(-eyeVec, NewNormal));
	    vec4 reflectCol = texture2D(reflectionSampler, refUVs.xy + vec2(refUVs.z, refUVs.w) *vec2(atan(reflection.y, reflection.x) / 2.0, acos(reflection.z)) / 3.14159);

		gl_FragColor.rgb = mix(gl_FragColor.rgb, reflectCol.rgb, min(2.0 * reflectionFactor, 1.0) * (reflectCol.r+reflectCol.g+reflectCol.b) / 3.0);
		if (reflectionFactor > 0.5)
		{
			gl_FragColor.rgb = mix(gl_FragColor.rgb, reflectCol.rgb, (2.0 * reflectionFactor - 1.0));
		}
	}
}
