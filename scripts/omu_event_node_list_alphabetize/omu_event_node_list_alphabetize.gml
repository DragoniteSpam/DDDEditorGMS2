/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);
ui_list_deselect(list);
var event = Stuff.event.active;

var selected_node = (selection + 1) ? event.nodes[| selection] : noone;

var sorted = ds_list_sort_name(event.nodes);
ds_list_destroy(event.nodes);
event.nodes = sorted;
// list entries is another reference
list.entries = sorted;

for (var i = 0; i < ds_list_size(event.nodes); i++) {
    if (event.nodes[| i] == selected_node) {
        ui_list_select(list, i, true);
        break;
    }
}