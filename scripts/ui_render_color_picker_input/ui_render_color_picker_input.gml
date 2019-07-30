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
var w = vx2 - vx1;
var h = vy2 - vy1;

switch (picker.axis_channel) {
    case ColorChannels.R:
        var c2 = colour_replace_red(c_white, picker.axis_value * 0xff);
        var c1 = colour_replace_green(c2, 0);
        var c3 = colour_replace_blue(c2, 0);;
        break;
    case ColorChannels.G:
        var c2 = colour_replace_green(c_white, picker.axis_value * 0xff);
        var c1 = colour_replace_blue(c2, 0);
        var c3 = colour_replace_red(c2, 0);
        break;
    case ColorChannels.B:
        var c2 = colour_replace_blue(c_white, picker.axis_value * 0xff);
        var c1 = colour_replace_red(c2, 0);
        var c3 = colour_replace_green(c2, 0);
        break;
}

if (active) {
    var inbounds = mouse_within_rectangle_determine(picker.check_view, vx1, vy1, vx2, vy2);
    if (inbounds && get_press_left()) {
        picker.selecting_color = true;
    }
}

if (picker.selecting_color) {
    var buckets = 16;
    var axis = picker.axis_value;
    var ww = clamp((Camera.MOUSE_X - vx1) / w, 0, 1);
    var hh = 1 - clamp((Camera.MOUSE_Y - vy1) / h, 0, 1);
    picker.selecting_color = Controller.mouse_left;
    
    if (!picker.all_colors) {
        axis = floor(axis * buckets) / buckets;
        ww = floor(ww * buckets) / buckets;
        hh = floor(hh * buckets) / buckets;
    }
    
    axis = axis * 0xff;
    ww = ww * 0xff;
    hh = hh * 0xff;
    
    switch (picker.axis_channel) {
        case ColorChannels.R: picker.value = (hh << 16) | (ww << 8) | axis; break;
        case ColorChannels.G: picker.value = (ww << 16) | (axis << 8) | hh; break;
        case ColorChannels.B: picker.value = (axis << 16) | (hh << 8) | ww; break;
    }
}

if (!picker.all_colors) {
    shader_set(shd_basic_colors);
}

draw_rectangle_colour(vx1, vy1, vx2, vy2, c1, c2, c3, c_black, false);
shader_reset();
draw_rectangle(vx1, vy1, vx2, vy2, true);

// COLOR AXIS

vx1 = x1 + picker.axis_x;
vy1 = y1 + picker.axis_y;
vx2 = vx1 + picker.axis_width;
vy2 = vy1 + picker.main_size;
var w = vx2 - vx1;
var h = vy2 - vy1;

if (active) {
    var inbounds = mouse_within_rectangle_determine(picker.check_view, vx1, vy1, vx2, vy2);
    if (inbounds && get_press_left()) {
        picker.selecting_axis = true;
    }
}

if (picker.selecting_axis) {
    picker.axis_value = clamp((Camera.MOUSE_Y - vy1) / h, 0, 1);
    picker.selecting_axis = Controller.mouse_left;
}

if (!picker.all_colors) {
    shader_set(shd_basic_colors);
}

var c = Stuff.color_channels[picker.axis_channel];
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c, c, false);
draw_rectangle(vx1, vy1, vx2, vy2, true);
shader_reset();
draw_rectangle(vx1, vy1, vx2, vy2, true);

var f = min(vy1 + h * picker.axis_value, vy2 - 1);
var c_axis = (picker.axis_channel == ColorChannels.R) ? 0x00ff00 : c_red;
draw_line_width_colour(vx1, f, vx2, f, 2, c_axis, c_axis);

// OUTPUT COLOR

vx1 = x1 + picker.output_x;
vy1 = y1 + picker.output_y;
vx2 = vx1 + picker.main_size;
vy2 = vy1 + picker.output_height;
var w = vx2 - vx1;
var h = vy2 - vy1;

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
var h = vy2 - vy1;

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
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, 0x00ff00, 0x00ff00, c_black, false);
shader_reset();
draw_rectangle(vx1, vy1, vx2, vy2, true);
var f = min(vx1 + w * picker.alpha, vx2 - 1);
draw_line_width_colour(f, vy1, f, vy2, 2, c_red, c_red);