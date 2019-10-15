/*////////////////////////////////////////////////////////////
This is a per-vertex shader for the SMF format.
It draws an animated and shaded model. Shading is done
per vertex, and the shader is therefore faster than the
per-fragment shader
////////////////////////////////////////////////////////////*/
attribute vec3 in_Position;                // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)    
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                  // (r, g, b, a) tangent
attribute vec4 in_Colour2;                 // (bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 // (weight1, weight2, weight3, weight4)

varying vec2 v_vTexcoord;
varying vec3 v_vShade;
varying vec3 v_vSpecular;
varying vec2 v_vReflectCoord;
varying float v_vReflectFactor;
varying float v_vRimLight;
varying float v_vOutline;

const int maxBones = 32;
uniform vec4 boneDQ[2*maxBones];
uniform int animate;

//Lights
const int MAXLIGHTS = 8;
uniform vec4 lightArray[MAXLIGHTS];
uniform int lightNum;
//Specular lighting
uniform float reflectivity;
uniform float damping;
//Rim lighting
uniform float rimPower;
uniform float rimFactor;
//Outline
uniform float outlineThickness;
//Reflection factor
uniform float reflectionFactor;
//Texture UVs
uniform vec4 texUVs;
uniform vec4 refUVs;
//Camera position
uniform vec3 camPos;

void main()
{
	vec3 WorldCameraPos = camPos;
	vec3 newPosition = in_Position;
	vec3 newNormal = in_Normal;
	vec3 hardNormal = in_Colour.xyz * 2.0 - 1.0;
	
	//Animate
	if (animate == 1)
	{
	    //Blend bones
		ivec4 bone = ivec4(in_Colour2 * 510.0);
		vec4 weight = in_Colour3;
	    vec4 blendReal = boneDQ[bone[0]] * weight[0] + boneDQ[bone[1]] * weight[1] + boneDQ[bone[2]] * weight[2] + boneDQ[bone[3]] * weight[3];
	    vec4 blendDual = boneDQ[bone[0]+1] * weight[0] + boneDQ[bone[1]+1] * weight[1] + boneDQ[bone[2]+1] * weight[2] + boneDQ[bone[3]+1] * weight[3];
	    //Normalize resulting dual quaternion
	    float blendNormReal = 1.0 / length(blendReal);
	    blendReal *= blendNormReal;
	    blendDual = (blendDual - blendReal * dot(blendReal, blendDual)) * blendNormReal;

	    //Transform vertex
	    /*Rotation*/	newPosition += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newPosition) + blendReal.w * newPosition);
	    /*Translation*/	newPosition += 2.0 * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
		/*Normal*/		newNormal += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newNormal) + blendReal.w * newNormal);
		/*Normal*/		hardNormal += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, hardNormal) + blendReal.w * hardNormal);
	}
	newNormal = normalize(newNormal);
	hardNormal = normalize(hardNormal);
	vec4 objectSpacePos = vec4(newPosition, 1.0);
    
    //Transform to world
    vec3 WorldNormal = normalize((gm_Matrices[MATRIX_WORLD] * vec4(newNormal, 0.0)).xyz);
	vec3 WorldPos = vec3(gm_Matrices[MATRIX_WORLD] * objectSpacePos);
    vec3 WorldCamVector = normalize(WorldCameraPos - WorldPos);
	vec3 WorldHardNormal = normalize((gm_Matrices[MATRIX_WORLD] * vec4(hardNormal, 0.0)).xyz);
	
	//Lighting
    v_vTexcoord = texUVs.xy + vec2(texUVs.y, texUVs.z) * in_TextureCoord;
	v_vShade = vec3(0.0);
	v_vSpecular = vec3(0.0);
	v_vReflectCoord = vec2(0.0);
	v_vReflectFactor = reflectionFactor;
	
	//Outline
	if (dot(WorldHardNormal, WorldCamVector) < 0.0)
	{
		vec4 tempPos = gm_Matrices[MATRIX_WORLD_VIEW] * objectSpacePos;
		objectSpacePos.xyz += 2.0 * newNormal * tempPos.z * outlineThickness;
		v_vOutline = 1.0;
	}
	else
	{
		//Reflection texcoord
		vec3 n = normalize(mat3(gm_Matrices[MATRIX_WORLD_VIEW]) * newNormal.xyz);
		v_vReflectCoord = refUVs.xy + vec2(refUVs.z, refUVs.w) * (0.5 - n.xy * 0.5);
		
		//Lighting
		for (int i = 0; i < MAXLIGHTS; i ++)
		{
			if (i >= lightNum){break;}
			vec3 lightDir;
			float att = 1.0;
			vec3 lightCol = vec3(1.0);
			//Point light
			if (lightArray[i*2].w > 0.0)
			{
				vec3 lightPos = lightArray[i*2].xyz;
				lightDir = WorldPos - lightPos;
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
				lightDir = WorldPos - lightPos;
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
			v_vShade += lightCol * max(0.0, -dot(WorldNormal, lightDir)) * att;
		
			//Specular
			if (damping > 0.0 && reflectivity > 0.0)
			{
			    vec3 reflectedLight = reflect(lightDir, WorldNormal);
			    float specFactor = max(dot(reflectedLight, WorldCamVector), 0.0);
			    float dampFactor = pow(specFactor, damping);
			    v_vSpecular += lightCol * dampFactor * reflectivity * att;
			}
		}
	
		//Rim lighting
		v_vRimLight = 0.0;
		if (rimPower > 0.0)
		{
			v_vRimLight = rimFactor * pow(1.0 - max(dot(WorldCamVector, WorldNormal), 0.0), rimPower);
		}
	}
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
}
