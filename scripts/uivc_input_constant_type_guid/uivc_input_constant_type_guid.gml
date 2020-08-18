/// @param UIList
function uivc_input_constant_type_guid(argument0) {

	var list = argument0;
	var base_dialog = list.root;
	var selection = ui_list_selection(base_dialog.el_list);

	if (selection + 1) {
	    var datadata = list.entries[| ui_list_selection(base_dialog.el_type_guid)];
	    var what = Stuff.all_game_constants[| selection];
	    what.type_guid = datadata.GUID;
	    what.value_guid = NULL;
    
	    var type = guid_get(what.type_guid);
	    var list_data = base_dialog.el_value_data;
    
	    list_data.entries = (what.type == DataTypes.DATA) ? type.instances : type.properties;
	    ui_list_deselect(list_data);
	}


}
