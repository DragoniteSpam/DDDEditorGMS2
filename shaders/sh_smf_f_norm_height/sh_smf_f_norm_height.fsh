//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vEyeVec;
varying mat3 v_vTBN;
varying vec3 v_vPos;

//Normal map
uniform sampler2D normalMapSampler;
uniform float normalMapFactor;
//Heightmap map
uniform float heightMapScale;
uniform float minSamples;
uniform float maxSamples;
const int maxHeightmapSamples = 80;
//Lights
const int MAXLIGHTS = 8;
uniform vec4 lightArray[MAXLIGHTS];
uniform int lightNum;
uniform vec3 ambientColor;
//Specular lighting
uniform float reflectivity;
uniform float damping;
//Cel shading
uniform float celSteps;
//Rim lighting
uniform float rimPower;
uniform float rimFactor;
//Texture UVs
uniform vec4 texUVs;
uniform vec4 nomUVs;

void main()
{
	vec2 TexCoord = v_vTexcoord;
	vec3 NewNormal = vec3(0, 0, 1);
	vec3 eyeVec = normalize(v_vEyeVec);
	vec3 tangentEyeVec = normalize(v_vEyeVec * v_vTBN);
	vec4 normCol = texture2D(normalMapSampler, nomUVs.xy + vec2(nomUVs.z, nomUVs.w) * TexCoord);
	float sampledHeight = mix(1.0, (2.0 * length(normCol.rgb - 0.5) - 0.25) / 0.75, heightMapScale);
	
	//Height map
	if (heightMapScale != 0.0)
	{
		vec2 maxOffset = tangentEyeVec.xy / tangentEyeVec.z * heightMapScale;
		int numSamples = int(mix(maxSamples, minSamples, tangentEyeVec.z));
		float stepSize = 1.0 / float(numSamples);
		
		float currRayHeight = 1.0;
		for (int currSample = 0; currSample < maxHeightmapSamples; currSample ++)
		{
			if (currSample >= numSamples){break;}
			if (sampledHeight > currRayHeight)
			{
				//If we're below the surface, step back and halve the step size, and continue the process
				currRayHeight += stepSize;
				TexCoord -= stepSize * maxOffset;
				stepSize /= 2.0;
			}
			currRayHeight -= stepSize;
			TexCoord += stepSize * maxOffset;
			normCol = texture2D(normalMapSampler, nomUVs.xy + vec2(nomUVs.z, nomUVs.w) * TexCoord);
			sampledHeight = mix(1.0, (2.0 * length(normCol.rgb - 0.5) - 0.25) / 0.75, heightMapScale);
		}
	}
	//Read normal, specular and displacement map
	vec3 NormalMapNormal = 2.0 * normCol.rgb - 1.0;
	NormalMapNormal.xy *= normalMapFactor;
	NormalMapNormal.z *= abs(1.0 - normalMapFactor);
	NewNormal = normalize(v_vTBN * NormalMapNormal);
	
	float SpecValue = normCol.w;
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
		    Specular += lightCol * SpecValue * dampFactor * reflectivity * att;
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
	
	vec4 baseCol = texture2D(gm_BaseTexture, texUVs.xy + vec2(texUVs.z, texUVs.w) * TexCoord);
	if (baseCol.a < 0.01){discard;}
    gl_FragColor = vec4(Specular + RimLight, 0.0) + vec4(ambientColor + Shade, 1.0) * baseCol;
}
