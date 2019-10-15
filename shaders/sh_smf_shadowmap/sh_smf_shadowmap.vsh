//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                // (x,y,z)  
attribute vec3 in_Normal;                  // (x,y,z)    
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                  // (r, g, b, a) tangent
attribute vec4 in_Colour2;                 // (bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 // (weight1, weight2, weight3, weight4)

varying float v_vDepth;

uniform float shadowNear;
uniform float shadowFar;

//Animation
const int maxBones = 32;
uniform vec4 boneDQ[2*maxBones];
uniform int animate;

void main()
{
	vec3 newPosition = in_Position;
	vec3 normal = in_Normal;
    vec2 texcoord = in_TextureCoord;
	vec4 colour = in_Colour;
	vec3 newNormal = in_Normal;
	
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
	}
	vec4 objectSpacePos = vec4(newPosition, 1.0);
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    v_vDepth = (gl_Position.z - shadowNear) / (shadowFar - shadowNear);
}