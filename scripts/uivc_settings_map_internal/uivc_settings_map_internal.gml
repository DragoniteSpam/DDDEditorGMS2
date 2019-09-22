/// @param UIThing

var thing = argument0;
var selection = ui_list_selection(thing.root.el_map_list);

if (selection >= 0) {
	var map = Stuff.all_maps[| selection];
	internal_name_set(map, thing.value);
}