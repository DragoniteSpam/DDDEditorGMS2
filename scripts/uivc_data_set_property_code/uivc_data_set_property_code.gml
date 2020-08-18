/// @param UIInputCode
function uivc_data_set_property_code(argument0) {

	var input = argument0;
	var data = guid_get(Stuff.data.ui.active_type_guid);
	var selection = ui_list_selection(Stuff.data.ui.el_instances);

	if (selection >= 0) {
	    // @gml
	    // because game maker can't handle doing all of these accessors in the same
	    // line apparently
	    var instance = data.instances[| selection];
	    ds_list_set(instance.values[| input.key], 0, input.value);
	}


}
