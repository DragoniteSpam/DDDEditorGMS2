/// @description uivc_list_selection_event_node(UIList);
/// @param UIList

if (Stuff.setting_alphabetize_lists) {
    var list=ds_list_sort_name_sucks(Stuff.active_event.nodes);
} else {
    var list=Stuff.active_event.nodes;
}

event_view_node(list[| ui_list_selection(argument0)]);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(list);
}
