/// @description smf_node_get_tovector(modelIndex, nodeIndex)
/// @param modelIndex
/// @param nodeIndex
var modelIndex = argument0;
var nodeList = modelIndex[| SMF_model.NodeList];
var M = nodeList[| argument1 * 4 + 1];
return [M[0], M[1], M[2]];