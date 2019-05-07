/// @description  uivc_bitfield_tile_flag(UIThing);
/// @param UIThing

var ts=get_active_tileset();

// you could use ^= but
var longexpr=ts.flags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y];
longexpr=longexpr^argument0.value;

ts.flags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]=longexpr;
