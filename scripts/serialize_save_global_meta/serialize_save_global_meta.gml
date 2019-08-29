/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.MISC_MAP_META);

// remember, this is a map of names; the values are just "true" so it's more
// of a hashset that just identifies if a thing is an associated map
var map_list = ds_map_to_list(Stuff.all_maps);

var n_maps = ds_list_size(map_list);
buffer_write(argument0, buffer_u16, n_maps);

for (var i = 0; i < n_maps; i++) {
    buffer_write(argument0, buffer_string, map_list[| i]);
}

// STARTING_MAP

buffer_write(argument0, buffer_string, Stuff.game_map_starting);

// GAMEPLAY_GRID

var bools = pack(Stuff.game_player_grid);
buffer_write(argument0, buffer_u32, bools);

ds_list_destroy(map_list);

// VARIABLE_BATTLE

buffer_write(argument0, buffer_u8, Stuff.game_battle_style);

// BASE_GAME_VARIABLES

var n_switches = ds_list_size(Stuff.switches);
var n_variables = ds_list_size(Stuff.variables);
buffer_write(argument0, buffer_u16, n_switches);
buffer_write(argument0, buffer_u16, n_variables);

for (var i = 0; i < n_switches; i++) {
    var sw_data = Stuff.switches[| i];
    buffer_write(argument0, buffer_string, sw_data[0]);
    buffer_write(argument0, buffer_bool, sw_data[1]);
}

for (var i = 0; i < n_variables; i++) {
    var var_data = Stuff.variables[| i];
    buffer_write(argument0, buffer_string, var_data[0]);
    buffer_write(argument0, buffer_f32, var_data[1]);
}