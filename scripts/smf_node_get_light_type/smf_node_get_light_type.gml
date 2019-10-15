/// @description smf_node_get_matrix(modelIndex, nodeIndex)
/// @param modelIndex
/// @param nodeIndex
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
var M = nodeList[| argument1 * 4 + 2];
return [M[12], M[13], M[14]];