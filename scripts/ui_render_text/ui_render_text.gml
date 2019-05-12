/// @description  void ui_render_text(UIText, x, y);
/// @param UIText
/// @param  x
/// @param  y

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

var tx=ui_get_text_x(argument0, x1, x2);
var ty=ui_get_text_y(argument0, y1, y2);

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text_ext(tx, ty, string(argument0.text), -1, argument0.wrap_width);
