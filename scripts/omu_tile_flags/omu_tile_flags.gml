/// @param UIButton

var button = argument0;
var xx = Stuff.map.selection_fill_tile_x;
var yy = Stuff.map.selection_fill_tile_y;

var data = vector2(xx, yy);
var tileset = get_active_tileset();
dialog_create_asset_flags(noone, "(" + string(xx) + ", " + string(yy) + ")", tileset.flags[# xx, yy], uivc_tile_set_flags, data);