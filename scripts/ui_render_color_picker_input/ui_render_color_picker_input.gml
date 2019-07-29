/// @param UIColorPickerInput
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

var vtx = vx1 + 12;
var vty = mean(vy1, vy2);

var c = validate_hex(picker.value_text) ? c_black : c_red;

if (!picker.interactive) {
    draw_rectangle_colour(vx1 + 1, vy1 + 1, vx2 - 1, vy2 - 1, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
}
draw_rectangle(vx1, vy1, vx2, vy2, true);

draw_text_ext_colour(vtx, vty, picker.value_text, -1, (vx2 - vtx), c, c, c, c, 1);
if (string_length(value) == 0) {
    draw_text_ext_colour(vtx, vty, picker.allow_alpha ? "RRGGBBAA" : "RRGGBB", -1, (vx2 - 2 * vtx), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (picker.interactive && dialog_is_active(picker.root)) {
    var inbounds = mouse_within_rectangle_determine(picker.check_view, vx1, vy1, vx2, vy2);
    if (inbounds) {
        if (get_release_left()) {
            
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(picker);
        }
    }
}

vx1 = x1 + picker.color_x;
vy1 = y1 + picker.color_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.main_size;

draw_rectangle(vx1, vy1, vx2, vy2, true);

vx1 = x1 + picker.axis_x;
vy1 = y1 + picker.axis_y;
vx2 = vx1 + picker.axis_width;
vy2 = vy1 + picker.main_size;

draw_rectangle(vx1, vy1, vx2, vy2, true);

vx1 = x1 + picker.output_x;
vy1 = y1 + picker.output_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.output_height;

draw_rectangle(vx1, vy1, vx2, vy2, true);

vx1 = x1 + picker.alpha_x;
vy1 = y1 + picker.alpha_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.alpha_height;

draw_text(tx, mean(vy1, vy2), "A");
draw_rectangle(vx1, vy1, vx2, vy2, true);