/// @description smf_model_draw_basic(modelIndex, texture)
/// @param modelIndex
/// @param texture
var modelIndex = argument0;
var modArray = modelIndex[| SMF_model.VBuff];
var texInd = modelIndex[| SMF_model.TextureIndex];
var num = array_length_1d(modArray);
for (var m = 0; m < num; m ++)
{
	vertex_submit(modArray[m], pr_trianglelist, argument1);
}