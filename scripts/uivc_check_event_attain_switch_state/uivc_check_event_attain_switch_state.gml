/// @param UICheckbox
function uivc_check_event_attain_switch_state(argument0) {

    var checkbox = argument0;

    var data = checkbox.root.node.custom_data[| 1];
    data[| 0] = checkbox.value;


}
