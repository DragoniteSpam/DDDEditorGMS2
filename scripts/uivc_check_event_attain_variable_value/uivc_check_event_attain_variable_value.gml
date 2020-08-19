/// @param UIInput
function uivc_check_event_attain_variable_value(argument0) {

    var input = argument0;

    var data = input.root.node.custom_data[| 1];
    data[| 0] = real(input.value);


}
