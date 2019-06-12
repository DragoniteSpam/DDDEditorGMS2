/// @param UIButton
/// @param x
/// @param y

var x1 = argument0.x + argument1;
var y1 = argument0.y + argument2;
var x2 = x1 +argument0.width;
var y2 = y1 + argument0.height;

var tx = ui_get_text_x(argument0, x1, x2);
var ty = ui_get_text_y(argument0, y1, y2);

ui_render_button_general(x1, y1, x2, y2, tx, ty, argument0.text, argument0.alignment, argument0.valignment, argument0.color,
    argument0.interactive && dialog_is_active(argument0.root), argument0.onmouseup, argument0);