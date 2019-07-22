/// @param UIText
/// @param x
/// @param y

var text = argument0;
var xx = argument1;
var yy = argument2;

var x1 = text.x + xx;
var y1 = text.y + yy;
var x2 = x1 + text.width;
var y2 = y1 + text.height;

var tx = ui_get_text_x(text, x1, x2);
var ty = ui_get_text_y(text, y1, y2);

draw_set_halign(text.alignment);
draw_set_valign(text.valignment);
draw_set_color(text.color);
draw_text_ext(tx, ty, string(text.text), -1, text.wrap_width);