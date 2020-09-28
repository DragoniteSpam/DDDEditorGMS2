/// @param UIInput
function uivc_input_event_attain_transfer_z(argument0) {

    var input = argument0;

    var data = input.root.node.custom_data[| 3];
    data[| 0] = real(input.value);


}
