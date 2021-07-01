/// @param UIInput
function uivc_input_custom_data_property_name(argument0) {

    var input = argument0;

    
    // this should work without this because of the accessor but
    // just because pass by reference in game maker sucks
    input.root.event.types[@ selection] = property;


}
