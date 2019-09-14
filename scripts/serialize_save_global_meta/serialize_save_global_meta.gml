/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MISC_MAP_META);

// STARTING_MAP

buffer_write(buffer, buffer_datatype, Stuff.game_starting_map);
// STARTING_POSITION
buffer_write(buffer, buffer_u16, Stuff.game_starting_x);
buffer_write(buffer, buffer_u16, Stuff.game_starting_y);
buffer_write(buffer, buffer_u16, Stuff.game_starting_z);

// GAMEPLAY_GRID

var bools = pack(Stuff.game_player_grid);
buffer_write(buffer, buffer_u32, bools);

// VARIABLE_BATTLE

buffer_write(buffer, buffer_u8, Stuff.game_battle_style);

// BASE_GAME_VARIABLES

var n_switches = ds_list_size(Stuff.switches);
var n_variables = ds_list_size(Stuff.variables);
buffer_write(buffer, buffer_u16, n_switches);
buffer_write(buffer, buffer_u16, n_variables);

for (var i = 0; i < n_switches; i++) {
    var sw_data = Stuff.switches[| i];
    buffer_write(buffer, buffer_string, sw_data[0]);
    buffer_write(buffer, buffer_bool, sw_data[1]);
}

for (var i = 0; i < n_variables; i++) {
    var var_data = Stuff.variables[| i];
    buffer_write(buffer, buffer_string, var_data[0]);
    buffer_write(buffer, buffer_f32, var_data[1]);
}