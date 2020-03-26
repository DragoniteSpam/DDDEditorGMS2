/// @param UIList

var list = argument0;
ui_list_deselect(list);

var sorted = ds_list_sort_name(Stuff.all_event_custom);
ds_list_destroy(Stuff.all_event_custom);
ui_list_deselect(list);
Stuff.all_event_custom = sorted;
// list entries is another reference
list.entries = sorted;