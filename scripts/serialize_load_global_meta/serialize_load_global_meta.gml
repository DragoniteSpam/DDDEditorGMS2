/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_maps = buffer_read(buffer, buffer_u16);
ds_map_clear(Stuff.all_maps);

repeat (n_maps) {
    ds_map_add(Stuff.all_maps, buffer_read(buffer, buffer_string), true);
}

if (version < DataVersions.NEW_MESH_SYSTEM) {
	buffer_read(buffer, buffer_string);
}

Stuff.game_map_starting = buffer_read(buffer, buffer_string);
var bools = buffer_read(buffer, buffer_u32);
Stuff.game_player_grid = unpack(bools, 0);
Stuff.game_battle_style = buffer_read(buffer, buffer_u8);

if (version >= DataVersions.GAME_VARIABLES) {
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
}