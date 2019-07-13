/// @param buffer
/// @param version

var version = argument1;

var n_maps = buffer_read(argument0, buffer_u16);
ds_map_clear(Stuff.all_maps);

repeat(n_maps) {
    ds_map_add(Stuff.all_maps, buffer_read(argument0, buffer_string), true);
}

var filename = buffer_read(argument0, buffer_string);
if (string_length(filename) > 0) {
    data_load_vra_on_the_fly(noone, PATH_VRA, filename);
} else {
    // warning that no vra is set?
}

Stuff.game_map_starting = buffer_read(argument0, buffer_string);
var bools = buffer_read(argument0, buffer_u32);
Stuff.game_player_grid = unpack(bools, 0);
Stuff.game_battle_style = buffer_read(argument0, buffer_u8);

if (argument1 >= DataVersions.GAME_VARIABLES) {
    var n_switches = buffer_read(argument0, buffer_u8);
    var n_variables = buffer_read(argument0, buffer_u8);
    
    for (var i = 0; i < n_switches; i++) {
        var sw_data = ["", false];
        sw_data[0] = buffer_read(argument0, buffer_string);
        sw_data[1] = buffer_read(argument0, buffer_bool);
        ds_list_add(Stuff.all_global_switches, sw_data);
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = ["", false];
        var_data[0] = buffer_read(argument0, buffer_string);
        var_data[1] = buffer_read(argument0, buffer_bool);
        ds_list_add(Stuff.all_global_variables, var_data);
    }
}