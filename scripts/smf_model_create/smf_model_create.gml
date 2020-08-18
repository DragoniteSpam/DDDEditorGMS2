/// @description smf_model_create(SMF_textureIndex);
/// @param SMF_textureIndex
function smf_model_create(argument0) {
	var modelIndex = ds_list_create();
	modelIndex[| SMF_model.Name] = "DynamicModel" + string(ds_list_size(SMF_modelList));
	modelIndex[| SMF_model.Compiled] = false;
	modelIndex[| SMF_model.Static] = true;
	modelIndex[| SMF_model.Center] = [0, 0, 0];
	modelIndex[| SMF_model.Size] = 0;
	modelIndex[| SMF_model.Material] = smf_model_material_create();

	modelIndex[| SMF_model.VBuff] = -1;
	modelIndex[| SMF_model.MBuff] = [buffer_create(1, buffer_grow, 1)];
	modelIndex[| SMF_model.Visible] = -1;
	modelIndex[| SMF_model.MaterialIndex] = -1;
	modelIndex[| SMF_model.TextureIndex] = [argument0];

	modelIndex[| SMF_model.NodeTypeMap] = ds_map_create();
	modelIndex[| SMF_model.NodeList] = ds_list_create();
	modelIndex[| SMF_model.Animation] = ds_list_create();
	modelIndex[| SMF_model.BindPose] = -1;

	modelIndex[| SMF_model.CollisionBuffer] = -1;
	modelIndex[| SMF_model.OctreeBuffer] = -1;
	modelIndex[| SMF_model.CollisionList] = -1;
	modelIndex[| SMF_model.OctreeList] = -1;
	modelIndex[| SMF_model.QuadtreeBuffer] = -1;

	ds_list_add(SMF_modelList, modelIndex, modelIndex[| SMF_model.Name]);

	return modelIndex;


}
