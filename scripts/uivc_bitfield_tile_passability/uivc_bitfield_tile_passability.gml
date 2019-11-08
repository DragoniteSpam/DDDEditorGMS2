/// @description uivc_bitfield_tile_passability(UIThing);
/// @param UIThing

var ts=get_active_tileset();

// you could use ^= but
var longexpr=ts.passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y];
longexpr=longexpr^argument0.value;

ts.passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y]=longexpr;
