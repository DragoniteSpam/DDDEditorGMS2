/// @description smf_node_get_property(modelIndex, nodeIndex, propertyIndex)
/// @param modelIndex
/// @param nodeIndex
/// @param propertyIndex
function smf_node_get_property(argument0, argument1, argument2) {
	var modelIndex = argument0;
	var nodeList = modelIndex[| SMF_model.NodeList];
	return ds_list_find_value(nodeList[| argument1 * 4 + 3], 2 * argument2 + 1);


}
