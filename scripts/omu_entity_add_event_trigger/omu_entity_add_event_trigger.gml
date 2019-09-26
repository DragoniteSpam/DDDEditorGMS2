/// @param UIButton

var button = argument0;

ds_list_add(Stuff.all_event_triggers, "Trigger " + string(ds_list_size(Stuff.all_event_triggers)));

button.interactive = ds_list_size(Stuff.all_event_triggers) < 32;
button.root.el_remove.interactive = ds_list_size(Stuff.all_event_triggers) > 1;
button.root.el_name.interactive = ds_list_size(Stuff.all_event_triggers) > 0;