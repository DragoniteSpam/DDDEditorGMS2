/// @param UIList
function uivc_list_event_condition_index(argument0) {

	var list = argument0;

	var data = list.root.node.custom_data[| 1];
	data[| list.root.index] = ui_list_selection(list);


}
