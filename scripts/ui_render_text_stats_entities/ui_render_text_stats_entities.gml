/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

text.text = string(ds_list_size(Stuff.active_map.all_entities));

ui_render_text(text, xx, yy);