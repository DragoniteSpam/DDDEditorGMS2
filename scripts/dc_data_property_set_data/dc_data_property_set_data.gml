/// @param UIThing
function dc_data_property_set_data(argument0) {

	var thing = argument0;
	var selection = ui_list_selection(thing.root.el_list_main);

	if (selection >= 0) {
	    var property = thing.root.root.root.selected_property;
    
	    var list_data = ds_list_create();
    
	    for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
	        if (Stuff.all_data[| i].type == DataTypes.DATA) {
	            ds_list_add(list_data, Stuff.all_data[| i]);
	        }
	    }
    
	    ds_list_sort_name(list_data);
	    property.type_guid = list_data[| selection].GUID;
	    ds_list_destroy(list_data);
    
	    thing.root.root.root.el_property_type_guid.text = guid_get(property.type_guid).name;
	    thing.root.root.root.el_property_type_guid.color = c_black;
	}

	dialog_destroy();


}
