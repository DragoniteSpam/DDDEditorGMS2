/// @description void ui_render_list_event_node(UIList, x, y);
/// @param UIList
/// @param x
/// @param y

var oldentries=argument0.entries;
//argument0.colorize=false;

if (Stuff.setting_alphabetize_lists) {
    argument0.entries=ds_list_sort_name_sucks(Stuff.active_event.nodes);
} else {
    argument0.entries=Stuff.active_event.nodes;
}

ui_render_list(argument0, argument1, argument2);

if (Stuff.setting_alphabetize_lists) {
    ds_list_destroy(argument0.entries);
}

// no memory leak, although the list isn't used
argument0.entries=oldentries;
