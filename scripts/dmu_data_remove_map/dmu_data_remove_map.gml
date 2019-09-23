/// @param UIButton

var button = argument0;
var list = button.root.el_map_list;
var index = ui_list_selection(list);
var map = Stuff.all_maps[| index];

if (map != Stuff.active_map) {
	selection_clear();
	load_a_map(map);
}

instance_activate_object(map);
instance_destroy(map);

if (ds_list_empty(Stuff.all_maps)) {
	dmu_data_add_map(button);
}

if (map == Stuff.active_map) {
	Stuff.active_map = noone;
	load_a_map(Stuff.all_maps[| 0]);
}

ui_list_deselect(button.root.el_map_list);
ds_map_add(button.root.el_map_list.selected_entries, ds_list_find_index(Stuff.all_maps, Stuff.active_map), true);