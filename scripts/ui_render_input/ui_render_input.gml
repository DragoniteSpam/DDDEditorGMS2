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
var offset = 12;

var vx1 = x1 + input.value_x1;
var vy1 = y1 + input.value_y1;
var vx2 = x1 + input.value_x2;
var vy2 = y1 + input.value_y2;
var ww = vx2 - vx1;
var hh = vy2 - vy1;

var tx = ui_get_text_x(input, x1, x2);
var ty = ui_get_text_y(input, y1, y2);

var value = string(input.value);
var sw = string_width(value);
var sw_end = sw + 4;

#region text label
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
#endregion

var vtx = vx1 + 12;
var vty = mean(vy1, vy2);
var spacing = 12;

// Drawing to the surface instead of the screen directly - everything drawn needs
// to be minus x1 and minus y1, because suddenly we're drawing at the origin again
#region input drawing
if (surface_exists(input.surface) && (surface_get_width(input.surface) != ww || surface_get_height(input.surface) != hh)) {
    surface_free(input.surface);
}

if (!surface_exists(input.surface)) {
    input.surface = surface_create(ww, hh);
}

surface_set_target(input.surface);
draw_clear_alpha(input.interactive ? input.back_color : c_ltgray, 1);

if (input.emphasis) {
    draw_set_font(FDefault12Italic);
}

var display_text = value + (ui_is_active(input) && (floor((current_time * 0.00125) % 2) == 0) ? "|" : "");
if (input.multi_line) {
    var valign = draw_get_valign();
    draw_set_valign(fa_top);
    var sh = string_height_ext(display_text, -1, vx2 - vx1 - (vtx - vx1) * 2);
    var vty = ui_get_text_y(input, vy1, vy2, fa_top);
    draw_text_ext_colour(vtx - vx1, min(vty - vy1, hh - spacing - sh), display_text, -1, vx2 - vx1 - (vtx - vx1) * 2, c, c, c, c, 1);
    draw_set_valign(valign);
} else {
    var sw_begin = min(vtx - vx1, ww - offset - sw);
    draw_text_colour(sw_begin, vty - vy1, display_text, c, c, c, c, 1);
    sw_end = sw_begin + sw + 4;
}
if (input.emphasis) {
    draw_set_font(FDefault12);
}
if (string_length(value) == 0) {
    draw_text_colour(vtx - vx1, vty - vy1, string(input.value_default), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
}

if (input.require_enter) {
    draw_sprite(spr_enter, 0, vx2 - sprite_get_width(spr_enter) - 4 - vx1, vty - sprite_get_height(spr_enter) / 2 - vy1);
}

if (input.interactive && dialog_is_active(input.root)) {
    if (ui_is_active(input)) {
        var v0 = value;
        value = string_copy(keyboard_string, 1, min(string_length(keyboard_string), input.value_limit));
        if (Controller.press_escape) {
            Controller.press_escape = false;
            value = "";
            keyboard_string = "";
        }
        if (input.multi_line && !input.require_enter && Controller.press_enter) {
            value = value + "\n";
            keyboard_string = keyboard_string + "\n";
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
                    input.emphasis = (input.validation == validate_string_internal_name && internal_name_get(input.value));
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

surface_reset_target();
#endregion

draw_surface(input.surface, vx1, vy1)
draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c_black, c_black, true);