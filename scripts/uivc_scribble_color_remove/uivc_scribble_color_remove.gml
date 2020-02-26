/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var mode = Stuff.scribble;
var selection = ui_list_selection(list);

ds_map_delete(global.__scribble_colours, list.entries[| selection]);
ds_list_delete(list.entries, selection);

button.root.el_add.interactive = true;
button.interactive = ds_list_size(list.entries) > 0;
button.root.el_add.interactive = false;
button.root.el_remove.interactive = false;
button.root.el_name.interactive = false;
button.root.el_value.interactive = false;
mode.scribble = noone;
scribble_cache_group_flush(SCRIBBLE_DEFAULT_CACHE_GROUP);