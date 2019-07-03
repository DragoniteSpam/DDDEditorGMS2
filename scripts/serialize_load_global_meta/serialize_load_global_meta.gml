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