/// @param UIThing

var thing = argument0;
var ts = get_active_tileset();

// you could use ^= but
var longexpr = ts.flags[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y];
longexpr = longexpr ^ thing.value;

ts.flags[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y] = longexpr;