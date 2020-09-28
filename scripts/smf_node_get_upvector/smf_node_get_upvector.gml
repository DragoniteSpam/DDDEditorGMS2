/// @description smf_node_get_upvector(modelIndex, nodeIndex)
/// @param modelIndex
/// @param nodeIndex
function smf_node_get_upvector(argument0, argument1) {
    var modelIndex = argument0;
    var nodeList = modelIndex[| SMF_model.NodeList];
    var M = nodeList[| argument1 * 4 + 1];
    return [M[8], M[9], M[10]];


}
