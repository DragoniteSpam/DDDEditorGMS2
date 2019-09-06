/// @param UIColorPicker
/// @param x
/// @param y

var picker = argument0;
var xx = argument1;
var yy = argument2;

var x1 = picker.x + xx;
var y1 = picker.y + yy;
var x2 = x1 + picker.width;
var y2 = y1 + picker.height;

var tx = ui_get_text_x(picker, x1, x2);
var ty = ui_get_text_y(picker, y1, y2);

var value = picker.value;

// this is not quite the same as ui_render_text
draw_set_halign(picker.alignment);
draw_set_valign(picker.valignment);
var c = picker.color;
draw_text_colour(tx, ty, picker.text, c, c, c, c, 1);

var vx1 = x1 + picker.value_x1;
var vy1 = y1 + picker.value_y1;
var vx2 = x1 + picker.value_x2;
var vy2 = y1 + picker.value_y2;

draw_rectangle_colour(vx1 + 1, vy1 + 1, vx2 - 1, vy2 - 1, picker.value, picker.value, picker.value, picker.value, false);
if (!picker.interactive) {
    draw_rectangle_colour(vx1 + 2, vy1 + 2, vx2 - 2, vy2 - 2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
    draw_rectangle_colour(vx1 + 3, vy1 + 3, vx2 - 3, vy2 - 3, c_ltgray, c_ltgray, c_ltgray, c_ltgray, true);
}
draw_rectangle(vx1, vy1, vx2, vy2, true);

if (picker.interactive && dialog_is_active(picker.root)) {
    var inbounds = mouse_within_rectangle_determine(vx1, vy1, vx2, vy2, picker.adjust_view);
    if (inbounds) {
        if (get_release_left()) {
            dialog_create_color_picker_options(picker, picker.value, uivc_color_picker_reflect);
        }
    }
}