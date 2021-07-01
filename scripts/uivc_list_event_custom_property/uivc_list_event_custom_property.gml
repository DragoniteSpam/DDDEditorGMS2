function uivc_list_event_custom_property(list) {
    var selection = ui_list_selection(list);
    
    if (selection + 1) {
        var property = list.root.event.types[selection];
        
        list.root.el_property_name.interactive = true;
        list.root.el_property_type.interactive = true;
        list.root.el_property_ext_type.interactive = true;
        list.root.el_property_type_guid.interactive = (property.type == DataTypes.DATA);
        
        ui_input_set_value(list.root.el_property_name, property.name);
        list.root.el_property_type.value = property.type;
        var datatype = guid_get(property.type_guid);
        list.root.el_property_type_guid.text = datatype ? ("Select (" + datatype.name + ")") : "Select Type...";
        
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