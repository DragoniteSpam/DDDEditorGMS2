/// @param UIThing

var thing = argument0;
var ts = get_active_tileset();

// you could use ^= but
var longexpr = ts.flags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y];
longexpr = longexpr ^ thing.value;

ts.flags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y] = longexpr;