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

// becasue this is going to get called several times, and it's not going to change
var active = picker.interactive && dialog_is_active(picker.root);

if (active) {
    var inbounds = mouse_within_rectangle_determine(picker.check_view, vx1, vy1, vx2, vy2);
    if (inbounds) {
        if (get_release_left()) {
            
        } else if (Controller.press_help) {
            //ds_stuff_help_auto(picker);
        }
    }
}

// COLOR PICKER

vx1 = x1 + picker.color_x;
vy1 = y1 + picker.color_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.main_size;

draw_rectangle(vx1, vy1, vx2, vy2, true);

// COLOR AXIS

vx1 = x1 + picker.axis_x;
vy1 = y1 + picker.axis_y;
vx2 = vx1 + picker.axis_width;
vy2 = vy1 + picker.main_size;

var c = Stuff.color_channels[picker.axis_channel];
draw_rectangle_colour(vx1, vy1, vx2, vy2, c, c, c_black, c_black, false);
draw_rectangle(vx1, vy1, vx2, vy2, true);

// OUTPUT COLOR

vx1 = x1 + picker.output_x;
vy1 = y1 + picker.output_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.output_height;

var c = picker.value;
draw_checkerbox(vx1, vy1, vx2 - vx1, vy2 - vy1, 2.25, 2.25);
draw_set_alpha(picker.alpha);
draw_rectangle_colour(vx1, vy1, vx2, vy2, c, c, c, c, false);
draw_set_alpha(1);
draw_rectangle(vx1, vy1, vx2, vy2, true);

// ALPHA

vx1 = x1 + picker.alpha_x;
vy1 = y1 + picker.alpha_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.alpha_height;
var w = vx2 - vx1;

if (active) {
    var inbounds = mouse_within_rectangle_determine(picker.check_view, vx1, vy1, vx2, vy2);
    if (inbounds && get_press_left()) {
        picker.selecting_alpha = true;
    }
}

if (picker.selecting_alpha) {
    picker.alpha = clamp((Camera.MOUSE_X - vx1) / w, 0, 1);
    picker.selecting_alpha = Controller.mouse_left;
}

draw_text(tx, mean(vy1, vy2), "A");
draw_checkerbox(vx1, vy1, vx2 - vx1, vy2 - vy1, 2.25, 2.25);
shader_set(shd_green_to_alpha);
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_green, c_green, c_black, false);
shader_reset();
var f = vx1 + w * picker.alpha;
draw_line_width_colour(f, vy1, f, vy2, 2, c_red, c_red);
draw_rectangle(vx1, vy1, vx2, vy2, true);
