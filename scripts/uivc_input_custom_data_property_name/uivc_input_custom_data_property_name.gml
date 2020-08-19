/// @param UIInput
function uivc_input_custom_data_property_name(argument0) {

    var input = argument0;

    var selection = ui_list_selection(input.root.el_list);
    var property = input.root.event.types[| selection];
    property[@ EventNodeCustomData.NAME] = input.value;
    
    // this should work without this because of the accessor but
    // just because pass by reference in game maker sucks
    input.root.event.types[| selection] = property;


}
