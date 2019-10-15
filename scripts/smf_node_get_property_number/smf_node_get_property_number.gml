/// @description smf_node_get_property_number(modelIndex, nodeInde)
/// @param modelIndex
/// @param nodeIndex
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
return ds_list_size(nodeList[| argument1 * 4 + 3]);