/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MISC_MAP_META);

var n_maps = ds_list_size(Stuff.all_maps);
buffer_write(buffer, buffer_u16, n_maps);

for (var i = 0; i < n_maps; i++) {
    buffer_write(buffer, buffer_string, Stuff.all_maps[| i]);
}

// STARTING_MAP

buffer_write(buffer, buffer_datatype, Stuff.game_map_starting);

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