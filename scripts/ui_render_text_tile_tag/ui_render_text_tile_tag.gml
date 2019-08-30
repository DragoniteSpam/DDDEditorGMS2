/// @param UIText
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

thing.text = ts.terrain_tag_names[| get_active_tileset().tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]];

ui_render_text(thing, xx, yy);