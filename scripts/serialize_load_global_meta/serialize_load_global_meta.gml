/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

Stuff.game_starting_map = buffer_read(buffer, buffer_datatype);

if (version >= DataVersions.STARTING_POSITION) {
	Stuff.game_starting_x = buffer_read(buffer, buffer_u16);
	Stuff.game_starting_y = buffer_read(buffer, buffer_u16);
	Stuff.game_starting_z = buffer_read(buffer, buffer_u16);
	if (version >= DataVersions.STARTING_DIRECTION) {
		Stuff.game_starting_direction = buffer_read(buffer, buffer_u8);
	}
}

var bools = buffer_read(buffer, buffer_u32);
Stuff.game_player_grid = unpack(bools, 0);
Stuff.game_battle_style = buffer_read(buffer, buffer_u8);

var n_switches = buffer_read(buffer, buffer_u16);
var n_variables = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_switches; i++) {
    var sw_data = ["", false];
    sw_data[0] = buffer_read(buffer, buffer_string);
    sw_data[1] = buffer_read(buffer, buffer_bool);
    ds_list_add(Stuff.switches, sw_data);
}

for (var i = 0; i < n_variables; i++) {
    var var_data = ["", false];
    var_data[0] = buffer_read(buffer, buffer_string);
    var_data[1] = buffer_read(buffer, buffer_f32);
    ds_list_add(Stuff.variables, var_data);
}