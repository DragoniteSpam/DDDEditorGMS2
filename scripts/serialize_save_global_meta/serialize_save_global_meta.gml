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

// VRAX_REFERENCE

buffer_write(argument0, buffer_string, Stuff.vra_name);

// STARTING_MAP

buffer_write(argument0, buffer_string, Stuff.game_map_starting);

// GAMEPLAY_GRID

var bools = pack(Stuff.game_player_grid);
buffer_write(argument0, buffer_u32, bools);

ds_list_destroy(map_list);

// VARIABLE_BATTLE

buffer_write(argument0, buffer_u8, Stuff.game_battle_style);

// MESH_AUTOTILE_INCLUSIONS

for (var i = 0; i < array_length_1d(Stuff.mesh_autotile_raw); i++) {
    var data = Stuff.mesh_autotile_raw[i];
    if (data == noone) {
        buffer_write(argument0, buffer_bool, false);
    } else {
        buffer_write(argument0, buffer_bool, true);
        buffer_copy(data, 0, buffer_get_size(data), argument0, buffer_tell(argument0));
    }
}