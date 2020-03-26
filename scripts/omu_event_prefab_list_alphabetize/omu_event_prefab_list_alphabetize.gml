/// @param UIList

var list = argument0;
ui_list_deselect(list);

var sorted = ds_list_sort_name(Stuff.all_event_prefabs);
ds_list_destroy(Stuff.all_event_prefabs);
ui_list_deselect(list);
Stuff.all_event_prefabs = sorted;
// list entries is another reference
list.entries = sorted;