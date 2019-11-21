/*////////////////////////////////////////////////////////////
This is a per-fragment shader for the SMF format.
It draws an animated and shaded model. Shading is done
per fragment, giving it optimal aesthetics at the cost
of performance.
////////////////////////////////////////////////////////////*/
attribute vec3 in_Position;                // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)    
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                  // (r, g, b, a) tangent
attribute vec4 in_Colour2;                 // (bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 // (weight1, weight2, weight3, weight4)

varying vec2 v_vTexcoord;
varying vec3 v_vEyeVec;
varying mat3 v_vTBN;
varying vec3 v_vPos;

const int maxBones = 32;
uniform vec4 boneDQ[2*maxBones];
uniform int animate;
//Camera position
uniform vec3 camPos;

void main()
{
    vec3 WorldCameraPos = camPos;
    vec3 newPosition = in_Position;
    vec3 newNormal = in_Normal;
    vec3 newTangent = in_Colour.xyz * 2.0 - 1.0;
    
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
        /*Rotation*/    newPosition += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newPosition) + blendReal.w * newPosition);
        /*Translation*/    newPosition += 2.0 * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
        /*Normal*/        newNormal += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newNormal) + blendReal.w * newNormal);
        /*Tangent*/        newTangent += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newTangent) + blendReal.w * newTangent);
    }
    
    vec4 objectSpacePos = vec4(newPosition, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    
    vec3 Normal = normalize(mat3(gm_Matrices[MATRIX_WORLD]) * newNormal);
    vec3 Tangent = normalize(mat3(gm_Matrices[MATRIX_WORLD]) * newTangent);
    vec3 Bitangent = normalize((cross(Tangent, Normal) * (in_Colour.w * 2.0 - 1.0)));
    
    //Varying variables
    v_vTBN = mat3(-Tangent, -Bitangent, Normal);
    v_vTexcoord = in_TextureCoord;
    v_vPos = vec3(gm_Matrices[MATRIX_WORLD] * objectSpacePos);
    v_vEyeVec = WorldCameraPos - v_vPos;
}
