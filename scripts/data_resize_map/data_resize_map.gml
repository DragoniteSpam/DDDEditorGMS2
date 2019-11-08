/// @param map
/// @param xx
/// @param yy
/// @param zz

var map = argument0;
var map_contents = map.contents;
var xx = argument1;
var yy = argument2;
var zz = argument3;

map.xx = xx;
map.yy = yy;
map.zz = zz;

for (var i = 0; i < ds_list_size(map_contents.all_entities); i++) {
    var thing = map_contents.all_entities[| i];
    if (thing.xx >= xx || thing.yy >= yy || thing.zz >= zz) {
        safa_delete(thing);
    }
}

graphics_create_grids();

ds_grid_resize(map_contents.map_grid, xx, yy);
map_fill_grid(map_contents.map_grid, zz);

if (Stuff.game_starting_map == map.GUID) {
	Stuff.game_starting_x = min(Stuff.game_starting_x, xx - 1);
	Stuff.game_starting_y = min(Stuff.game_starting_y, yy - 1);
	Stuff.game_starting_z = min(Stuff.game_starting_z, zz - 1);
}

Stuff.map.ui.element_entity_pos_x.value_upper = xx - 1;
Stuff.map.ui.element_entity_pos_y.value_upper = yy - 1;
Stuff.map.ui.element_entity_pos_z.value_upper = zz - 1;