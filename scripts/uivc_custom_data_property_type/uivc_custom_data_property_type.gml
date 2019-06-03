/// @description uivc_custom_data_property_type(UIThing);
/// @param UIThing

var selection=ui_list_selection(argument0.root.root.el_list);

var property=argument0.root.root.event.types[| selection];
property[EventNodeCustomData.TYPE]=argument0.value;
argument0.root.root.changed=true;

// this should work without this because of the accessor but
// just because pass by reference in game maker sucks
argument0.root.root.event.types[| selection]=property;

argument0.root.root.el_property_type_guid.interactive=(argument0.value==DataTypes.ENUM||argument0.value==DataTypes.DATA);
switch (argument0.value) {
    case DataTypes.ENUM:
        argument0.root.root.el_property_type_guid.interactive=true;
        argument0.root.root.el_property_type_guid.onmouseup=omu_event_custom_enum_select;
        break;
    case DataTypes.DATA:
        argument0.root.root.el_property_type_guid.interactive=true;
        argument0.root.root.el_property_type_guid.onmouseup=omu_event_custom_data_select;
        break;
    default:
        argument0.root.root.el_property_type_guid.interactive=false;
        argument0.root.root.el_property_type_guid.onmouseup=null;
        break;
}
