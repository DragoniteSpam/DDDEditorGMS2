/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var index = ui_list_selection(list);

ds_list_delete(Stuff.all_event_triggers, index);

if (index >= ds_list_size(Stuff.all_event_triggers)) {
	ui_list_deselect(list);
	ds_map_add(list.selected_entries, --index, true);
}

ui_input_set_value(button.root.el_name, Stuff.all_event_triggers[| index]);

button.root.el_add.interactive = ds_list_size(Stuff.all_event_triggers) < 32;
button.interactive = ds_list_size(Stuff.all_event_triggers) > 4;
button.root.el_name.interactive = ds_list_size(Stuff.all_event_triggers) > 0;