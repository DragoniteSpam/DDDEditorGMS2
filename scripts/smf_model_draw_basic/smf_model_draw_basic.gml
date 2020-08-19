/// @description smf_model_draw_basic(modelIndex, texture)
/// @param modelIndex
/// @param texture
function smf_model_draw_basic(argument0, argument1) {
	var modelIndex = argument0;
	var modArray = modelIndex[| SMF_model.VBuff];
	var texInd = modelIndex[| SMF_model.TextureIndex];
	var num = array_length(modArray);
	for (var m = 0; m < num; m ++)
	{
	    vertex_submit(modArray[m], pr_trianglelist, argument1);
	}


}
