/// @param UIList
function uivc_list_event_custom_outbound(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);

    ui_input_set_value(list.root.el_outbound_name, list.root.event.outbound[| selection]);


}
