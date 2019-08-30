/// @param UIText
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

var ts = get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]) {
    thing.text = ts.terrain_tag_names[| ts.at_tags[Camera.selection_fill_autotile]];
}

ui_render_text(thing, xx, yy);