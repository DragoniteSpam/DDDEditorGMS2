/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    var property = list.root.event.types[| selection];
    
    list.root.el_property_name.interactive = true;
    list.root.el_property_type.interactive = true;
    list.root.el_property_ext_type.interactive = true;
    list.root.el_property_type_guid.interactive = (property[EventNodeCustomData.TYPE] == DataTypes.DATA);
    //list.root.el_property_max.interactive = true;
    //list.root.el_property_all.interactive = true;
    
    list.root.el_property_name.value = property[EventNodeCustomData.NAME];
    list.root.el_property_type.value = property[EventNodeCustomData.TYPE];
    //list.root.el_property_max.value = string(property[EventNodeCustomData.MAX]);
    //list.root.el_property_all.value = property[EventNodeCustomData.REQUIRED];
    
    var datatype = guid_get(property[EventNodeCustomData.TYPE_GUID]);
    if (datatype) {
        list.root.el_property_type_guid.text = "Select (" + datatype.name + ")";
    } else {
        list.root.el_property_type_guid.text = "Select";
    }
    
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