/// @description smf_node_get_matrix(modelIndex, nodeIndex)
/// @param modelIndex
/// @param nodeIndex
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
return nodeList[| argument1 * 4 + 1];