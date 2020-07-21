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

var old_halign = global.scribble_state_box_halign;
var old_valign = global.scribble_state_box_valign;
scribble_set_box_align(text.alignment, text.valignment);
scribble_set_wrap(text.wrap_height, text.wrap_width, -1);
scribble_draw(tx, ty, string(text.text));
scribble_set_box_align(old_halign, old_valign);

if (mouse_within_rectangle_determine(x1, y1, x2, y2, text.adjust_view)) {
    Stuff.element_tooltip = text;
}

ui_handle_dropped_files(text);