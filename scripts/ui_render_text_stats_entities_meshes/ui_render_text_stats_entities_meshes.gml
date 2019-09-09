/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

text.text = string(Stuff.active_map.contents.population[ETypes.ENTITY_MESH]);

ui_render_text(text, xx, yy);