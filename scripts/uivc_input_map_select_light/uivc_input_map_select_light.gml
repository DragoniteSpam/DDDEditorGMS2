/// @param UIList

var list = argument0;
var active_list = list.root.el_light_list;
var selection = ui_list_selection(list);
var active_selection = ui_list_selection(active_list);

if (active_selection + 1) {
    if (selection + 1) {
        active_list.entries[| active_selection] = list.entries[| selection];
    } else {
        active_list.entries[| active_selection] = 0;
    }
}