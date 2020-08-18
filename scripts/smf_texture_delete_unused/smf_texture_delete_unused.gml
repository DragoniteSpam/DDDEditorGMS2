/// @description smf_delete_unused_textures()
function smf_texture_delete_unused() {
	show_debug_message("Test1");
	for (var i = 0; i < ds_list_size(SMF_textureList); i += 3)
	{
	    if !SMF_textureList[| i + 2] continue;
	    var currentTex = SMF_textureList[| i];
	    if (currentTex == -1) continue;
	    var jNum = ds_list_size(SMF_modelList);
	    for (var j = 0; j < jNum; j += 2)
	    {
	        var modelIndex = SMF_modelList[| j];
	        var texInd = modelIndex[| SMF_model.TextureIndex];
	        var mNum = array_length_1d(texInd);
	        for (var m = 0; m < mNum; m ++){
	            if (texInd[m] == i) break;}
	        var material = modelIndex[| SMF_model.Material];
	        var matNum = ds_grid_width(material);
	        for (var mat = 0; mat < matNum; mat ++)
	        {
	            if material[# mat, SMF_mat.NormalMap] == i{j = jNum; break;}
	            if material[# mat, SMF_mat.ReflectionMap] == i{j = jNum; break;}
	        }
	    }
	    if (j == jNum)
	    {
	        sprite_delete(currentTex);
	        SMF_textureList[| i] = -1;
	        SMF_textureList[| i+1] = -1;
	    }
	}
	show_debug_message("Test2");


}
