/// @param UIList
function uivc_list_selection_event_triggers(argument0) {

    var list = argument0;
    var selection = ui_list_selection(list);
    var base_dialog = list.root;

    ui_input_set_value(base_dialog.el_name, Stuff.all_event_triggers[| selection]);


}
