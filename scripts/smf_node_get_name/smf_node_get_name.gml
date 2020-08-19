/// @description smf_node_get_name(modelIndex, nodeIndex)
/// @param modelIndex
/// @param nodeIndex
function smf_node_get_name(argument0, argument1) {
    /*
    Returns the name of the model
    */
    var modelIndex = argument0;
    var nodeType = modelIndex[| SMF_model.NodeTypeMap];
    var nodeList = modelIndex[| SMF_model.NodeList];
    return nodeType[? nodeList[| argument1 * 4]];


}
