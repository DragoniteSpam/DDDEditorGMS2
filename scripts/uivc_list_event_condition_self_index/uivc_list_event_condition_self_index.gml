/// @param UIRadio
function uivc_list_event_condition_self_index(argument0) {

    var radio = argument0;

    radio.root.root.node.custom_data[1][radio.root.root.index] = radio.value;


}
