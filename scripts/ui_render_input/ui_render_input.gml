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
draw_text_colour(tx, ty, string(input.text), c, c, c, c, 1);
draw_set_valign(fa_middle);

if (script_execute(input.validation, value, input)) {
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
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c_black, c_black, true);

draw_text_ext_colour(vtx, vty, string(value), -1, vx2 - vtx, c, c, c, c, 1);
if (string_length(value) == 0) {
    draw_text_ext_colour(vtx, vty, string(string(input.value_default)), -1, vx2 - vtx, c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (input.require_enter) {
    draw_sprite(spr_enter, 0, vx2 - sprite_get_width(spr_enter) - 4, vty - sprite_get_height(spr_enter) / 2);
}

if (input.interactive && dialog_is_active(input.root)) {
    if (ui_is_active(input)) {
        // this will not work correctly if there are line breaks, but fixing that is
        // like the bottom of the priority queue right now
        if (floor((current_second * 1.25) % 2) == 0) {
            var bx = vtx + string_width(string(value)) + 4;
            draw_line_width_colour(bx, vty - 7, bx, vty + 7, 2, c_black, c_black);
        }
        var v0 = value;
        value = string_copy(keyboard_string, 1, min(string_length(keyboard_string), input.value_limit));
        if (Controller.press_escape) {
            Controller.press_escape = false;
            value = "";
            keyboard_string = "";
        }
        input.value = value;
        
        if (script_execute(input.validation, value, input)) {
            var execute_value_change = (!input.require_enter && v0 != value) || (input.require_enter && Controller.press_enter);
            if (execute_value_change) {
                if (input.real_value) {
                    var n = script_execute(input.value_conversion, value);
                    execute_value_change = execute_value_change && is_clamped(n, input.value_lower, input.value_upper);
                }
                if (execute_value_change) {
                    script_execute(input.onvaluechange, input);
                }
            }
        }
    }
    // activation
    var inbounds = mouse_within_rectangle_determine(vx1, vy1, vx2, vy2, input.adjust_view);
    if (inbounds) {
        if (Controller.release_left) {
            keyboard_string = input.value;
            ui_activate(input);
        }
        Stuff.element_tooltip = input;
    }
}