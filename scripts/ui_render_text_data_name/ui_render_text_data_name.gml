/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

text.text = (text.root.active_type_guid != NULL) ? guid_get(text.root.active_type_guid).name : text.text = "No Data Selected";

ui_render_text(text, xx, yy);