/// @param UICheckbox
function uivc_custom_data_property_required(argument0) {

    var checkbox = argument0;

    var selection = ui_list_selection(checkbox.root.el_list);

    var property = checkbox.root.event.types[selection];
    property.all_required = checkbox.value;

    // this should work without this because of the accessor but
    // just because pass by reference in game maker sucks
    checkbox.root.event.types[@ selection] = property;


}
