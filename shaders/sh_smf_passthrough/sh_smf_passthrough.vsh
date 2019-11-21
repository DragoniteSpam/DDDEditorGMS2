/*////////////////////////////////////////////////////////////
This is the bare-bones passthrough shader for the SMF format.
It draws a static model with a given texture
////////////////////////////////////////////////////////////*/
attribute vec3 in_Position;                // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                  // tangent
attribute vec4 in_Colour2;                 //(bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 //(weight1, weight2, weight3, weight4)

varying vec2 v_vTexcoord;
//Texture UVs
uniform vec4 texUVs;

void main()
{
    vec3 newPosition = in_Position;
    vec3 newNormal = in_Normal;
    vec3 newTangent = in_Colour.xyz * 2.0 - 1.0;
    
    v_vTexcoord = texUVs.xy + vec2(texUVs.z, texUVs.w) * in_TextureCoord;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
}