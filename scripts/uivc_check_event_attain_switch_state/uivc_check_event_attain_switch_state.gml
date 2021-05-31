/// @param UICheckbox
function uivc_check_event_attain_switch_state(argument0) {

    var checkbox = argument0;

    checkbox.root.node.custom_data[1][0] = checkbox.value;


}
