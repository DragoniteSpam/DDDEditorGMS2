/// @description smf_node_get_upvector(modelIndex)
/// @param modelIndex
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
return ds_list_size(nodeList) / 4;