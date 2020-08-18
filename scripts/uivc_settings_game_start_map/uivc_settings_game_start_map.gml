/// @param UIThing
function uivc_settings_game_start_map(argument0) {

	var thing = argument0;
	var map = Stuff.all_maps[| thing.value];

	Stuff.game_starting_map = map.GUID;

	thing.root.el_x.value_upper = map.xx;
	thing.root.el_y.value_upper = map.yy;
	thing.root.el_z.value_upper = map.zz;

	Stuff.game_starting_x = min(map.xx - 1, Stuff.game_starting_x);
	Stuff.game_starting_y = min(map.yy - 1, Stuff.game_starting_y);
	Stuff.game_starting_z = min(map.zz - 1, Stuff.game_starting_z);

	ui_input_set_value(thing.root.el_x, string(Stuff.game_starting_x));
	ui_input_set_value(thing.root.el_y, string(Stuff.game_starting_y));
	ui_input_set_value(thing.root.el_z, string(Stuff.game_starting_z));


}
