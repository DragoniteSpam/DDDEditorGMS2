/// @param UIInput
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var x1 = input.x + xx;
var y1 = input.y + yy;
var x2 = x1 + input.width;
var y2 = y1 + input.height;

var tx = ui_get_text_x(input, x1, x2);
var ty = ui_get_text_y(input, y1, y2);

var value = input.value;

// this is not quite the same as ui_render_text
draw_set_halign(input.alignment);
draw_set_valign(input.valignment);
var c = input.color;
var prefix = input.require_enter ? "^" : "";
draw_text_colour(tx, ty, prefix + string(input.text), c, c, c, c, 1);

if (script_execute(input.validation, value)) {
    var c = input.color;
    if (input.real_value) {
        var n = script_execute(input.value_conversion, value);
        if (!is_clamped(n, input.value_lower, input.value_upper)) {
            c = c_orange;
        }
    }
} else {
    var c = c_red;
}

var vx1 = x1 + input.value_x1;
var vy1 = y1 + input.value_y1;
var vx2 = x1 + input.value_x2;
var vy2 = y1 + input.value_y2;

var vtx = vx1 + 12;
var vty = mean(vy1, vy2);

var c_back = input.interactive ? input.back_color : c_ltgray;
draw_rectangle_colour(vx1 + 1, vy1 + 1, vx2 - 1, vy2 - 1, c_back, c_back, c_back, c_back, false);
draw_rectangle(vx1, vy1, vx2, vy2, true);

draw_text_ext_colour(vtx, vty, string(value), -1, (vx2 - vtx), c, c, c, c, 1);
if (string_length(value) == 0) {
    draw_text_ext_colour(vtx, vty, string(string(input.value_default)), -1, (vx2 - 2 * vtx), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (input.interactive && dialog_is_active(input.root)) {
    if (ui_is_active(input)) {
        // this will not work correctly if there are line breaks, but fixing that is
        // like the bottom of the priority queue right now
        if (current_second % 2 == 0) {
            var bx = tx + input.value_x1 + string_width(string(value)) + 4;
            draw_line_width(bx, ty - 7, bx, ty + 7, 2);
        }
        var v0 = value;
        value = value + keyboard_string;
        keyboard_string = "";
        if (keyboard_check_pressed(vk_backspace)) {
            value = string_backspace(value);
        }
        if (get_release_escape()) {
            value = "";
        }
        if (string_length(value) > input.value_limit) {
            value = string_copy(value, 1, input.value_limit);
        }
        
        input.value = value;
        
        if (script_execute(input.validation, value)) {
            var execute_value_change = (!input.require_enter && v0 != value) || (input.require_enter && keyboard_check_pressed(vk_enter));
            if (execute_value_change) {
                script_execute(input.onvaluechange, input);
            }
        }
    }
    
    var inbounds = mouse_within_rectangle_determine(vx1, vy1, vx2, vy2, input.adjust_view);
    if (inbounds) {
        if (get_release_left()) {
            ui_activate(input);
            keyboard_string = "";
        }
    } else {
        if (Controller.release_left) {
            ui_activate(noone);
        }
    }
}