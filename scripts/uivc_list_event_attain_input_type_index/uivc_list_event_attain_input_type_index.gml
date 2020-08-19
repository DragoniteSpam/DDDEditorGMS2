/// @param UIRadio
function uivc_list_event_attain_input_type_index(argument0) {

    var radio = argument0;

    var data = radio.root.root.node.custom_data[| 2];
    data[| 0] = radio.root.value;


}
