/// @param UIInput
function uivc_input_event_custom_outbound_name(argument0) {

    var input = argument0;

    var selection = ui_list_selection(input.root.el_outbound);
    input.root.event.outbound[selection] = input.value;


}
