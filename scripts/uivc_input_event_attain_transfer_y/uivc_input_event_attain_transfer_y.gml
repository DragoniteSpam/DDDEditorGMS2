/// @param UIInput
function uivc_input_event_attain_transfer_y(argument0) {

    var input = argument0;

    var data = input.root.node.custom_data[| 2];
    data[| 0] = real(input.value);


}
