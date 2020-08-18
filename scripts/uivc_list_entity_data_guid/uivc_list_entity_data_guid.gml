/// @param UIList
function uivc_list_entity_data_guid(argument0) {

	var list = argument0;

	var selection = ui_list_selection(list);
	var generic_index = ui_list_selection(list.root.el_list);

	if (selection + 1) {
	    list.root.entity.generic_data[| generic_index].value_data = list.entries[| selection].GUID;
	}


}
