/// @param UIThing
function uivc_custom_data_property_type(argument0) {

    var thing = argument0;

    var selection = ui_list_selection(thing.root.root.el_list);

    var property = thing.root.root.event.types[selection];
    property.type = thing.value;

    // this should work without this because of the accessor but
    // just because pass by reference in game maker sucks
    thing.root.root.event.types[@ selection] = property;

    thing.root.root.el_property_type_guid.interactive = (thing.value == DataTypes.ENUM || thing.value == DataTypes.DATA);

    switch (thing.value) {
        case DataTypes.ENUM:
            thing.root.root.el_property_type_guid.interactive = true;
            thing.root.root.el_property_type_guid.onmouseup = omu_event_custom_enum_select;
            break;
        case DataTypes.DATA:
            thing.root.root.el_property_type_guid.interactive = true;
            thing.root.root.el_property_type_guid.onmouseup = omu_event_custom_data_select;
            break;
        default:
            thing.root.root.el_property_type_guid.interactive = false;
            thing.root.root.el_property_type_guid.onmouseup = null;
            break;
    }


}
