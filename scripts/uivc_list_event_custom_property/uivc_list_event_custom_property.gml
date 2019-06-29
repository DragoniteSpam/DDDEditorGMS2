/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    // do not alphabetize these
    var property = argument0.root.event.types[| selection];
    
    argument0.root.el_property_name.interactive = true;
    argument0.root.el_property_type.interactive = true;
    argument0.root.el_property_ext_type.interactive = true;
    argument0.root.el_property_type_guid.interactive = (property[EventNodeCustomData.TYPE] == DataTypes.DATA);
    argument0.root.el_property_max.interactive = true;
    argument0.root.el_property_all.interactive = true;
    
    argument0.root.el_property_name.value = property[EventNodeCustomData.NAME];
    argument0.root.el_property_type.value = property[EventNodeCustomData.TYPE];
    argument0.root.el_property_max.value = string(property[EventNodeCustomData.MAX]);
    argument0.root.el_property_all.value = property[EventNodeCustomData.REQUIRED];
    
    var datatype = guid_get(property[EventNodeCustomData.TYPE_GUID]);
    if (datatype != noone) {
        argument0.root.el_property_type_guid.text = "Select (" + datatype.name + ")";
    } else {
        argument0.root.el_property_type_guid.text = "Select";
    }
    
    // set the behavior of the button based on the data type
    switch (argument0.root.el_property_type.value) {
        case DataTypes.ENUM:
            argument0.root.el_property_type_guid.interactive = true;
            argument0.root.el_property_type_guid.onmouseup = omu_event_custom_enum_select;
            break;
        case DataTypes.DATA:
            argument0.root.el_property_type_guid.interactive = true;
            argument0.root.el_property_type_guid.onmouseup = omu_event_custom_data_select;
            break;
        default:
            argument0.root.el_property_type_guid.interactive = false;
            argument0.root.el_property_type_guid.onmouseup = null;
            break;
    }

}