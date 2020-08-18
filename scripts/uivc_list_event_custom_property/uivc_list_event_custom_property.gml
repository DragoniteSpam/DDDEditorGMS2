/// @param UIList
function uivc_list_event_custom_property(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection >= 0) {
	    var property = list.root.event.types[| selection];
    
	    list.root.el_property_name.interactive = true;
	    list.root.el_property_type.interactive = true;
	    list.root.el_property_ext_type.interactive = true;
	    list.root.el_property_type_guid.interactive = (property[EventNodeCustomData.TYPE] == DataTypes.DATA);
    
	    ui_input_set_value(list.root.el_property_name, property[EventNodeCustomData.NAME]);
	    list.root.el_property_type.value = property[EventNodeCustomData.TYPE];
    
	    var datatype = guid_get(property[EventNodeCustomData.TYPE_GUID]);
	    list.root.el_property_type_guid.text = datatype? "Select (" + datatype.name + ")" : list.root.el_property_type_guid.text = "Select";
    
	    // set the behavior of the button based on the data type
	    switch (list.root.el_property_type.value) {
	        case DataTypes.ENUM:
	            list.root.el_property_type_guid.interactive = true;
	            list.root.el_property_type_guid.onmouseup = omu_event_custom_enum_select;
	            break;
	        case DataTypes.DATA:
	            list.root.el_property_type_guid.interactive = true;
	            list.root.el_property_type_guid.onmouseup = omu_event_custom_data_select;
	            break;
	        default:
	            list.root.el_property_type_guid.interactive = false;
	            list.root.el_property_type_guid.onmouseup = null;
	            break;
	    }
	}


}
