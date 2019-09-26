/// @param UIButton

var button = argument0;
var index = ui_list_selection(button.root.el_list);

ds_list_delete(Stuff.all_event_triggers, index);

button.root.el_add.interactive = ds_list_size(Stuff.all_event_triggers) < 32;
button.interactive = ds_list_size(Stuff.all_event_triggers) > 1;
button.root.el_name.interactive = ds_list_size(Stuff.all_event_triggers) > 0;