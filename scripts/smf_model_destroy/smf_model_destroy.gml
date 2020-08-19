/// @description smf_export_compiled_model(modelIndex)
/// @param modelIndex
function smf_model_destroy(argument0) {
	/*
	Destroy an SMF model

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var modelIndex = argument0;
	if modelIndex == -1{exit;}
	if !ds_exists(modelIndex, ds_type_list){exit;}
	show_debug_message("Destroying SMF model " + string(modelIndex[| SMF_model.Name]))
	var materials = modelIndex[| SMF_model.Material];
	var modArray = modelIndex[| SMF_model.VBuff];
	var bufArray = modelIndex[| SMF_model.MBuff];
	var matInd = modelIndex[| SMF_model.MaterialIndex];
	var texInd = modelIndex[| SMF_model.TextureIndex];
	var nodeType = modelIndex[| SMF_model.NodeTypeMap];
	var nodeScale = modelIndex[| SMF_model.NodeScale];
	var nodeList = modelIndex[| SMF_model.NodeList];
	var colBuff = modelIndex[| SMF_model.CollisionBuffer];
	var octBuff = modelIndex[| SMF_model.OctreeBuffer];
	var colList = modelIndex[| SMF_model.CollisionList];
	var octList = modelIndex[| SMF_model.OctreeList];
	var quadBuff = modelIndex[| SMF_model.QuadtreeBuffer];
	var bindPose = modelIndex[| SMF_model.BindPose];
	var animationList = modelIndex[| SMF_model.Animation];
	var Visible = modelIndex[| SMF_model.Visible];
	var amCol = modelIndex[| SMF_model.AmbientColor];
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete materials
	ds_grid_destroy(materials);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete vertex buffers
	var modelNum = array_length(modArray);
	for (var m = 0; m < modelNum; m ++){
	    vertex_delete_buffer(modArray[m]);
	    if bufArray[m] >= 0{buffer_delete(bufArray[m])};}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete nodes
	var nodeNum = ds_list_size(nodeList) / 4;
	for (var i = 0; i < nodeNum; i ++){    
	    var propertyList = nodeList[| i*4 + 3];
	    //Write properties
	    for (var j = 0; j < ds_list_size(propertyList) / 2; j ++)
	    {
	        if propertyList[| j*2] == 2
	        {
	            smf_path_destroy(propertyList[| j*2 + 1]);
	        }
	    }
	}
	ds_list_destroy(nodeList);
	ds_map_destroy(nodeType);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete collision buffer
	if colBuff >= 0 and octBuff >= 0{
	    buffer_delete(colBuff);
	    buffer_delete(octBuff);}
	if colList >= 0 and octList >= 0{
	    ds_list_destroy(colList);
	    ds_list_destroy(octList);}
	if quadBuff >= 0{
	    buffer_delete(quadBuff);}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete rig
	if bindPose != -1{
	    ds_list_destroy(bindPose);
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Delete animations
	var frameNum, frameGrid;
	var animationNum = ds_list_size(animationList) / 3;
	for (var a = 0; a < animationNum; a ++){
	    frameGrid = animationList[| a * 3 + 1];
	    ds_grid_destroy(frameGrid);
	}
	if animationNum{ds_list_destroy(animationList);}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//The model index
	ds_list_destroy(modelIndex);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Remove from model list
	var index = ds_list_find_index(SMF_modelList, modelIndex);
	repeat 2{ds_list_delete(SMF_modelList, index);}


}
