function ui_render_input(input, xx, yy) {
    var x1 = input.x + xx;
    var y1 = input.y + yy;
    var x2 = x1 + input.width;
    var y2 = y1 + input.height;
    var offset = 12;
    var c = input.color;
    
    var vx1 = x1 + input.value_x1;
    var vy1 = y1 + input.value_y1;
    var vx2 = x1 + input.value_x2;
    var vy2 = y1 + input.value_y2;
    var ww = vx2 - vx1;
    var hh = vy2 - vy1;
    
    var tx = input.GetTextX(x1, x2);
    var ty = input.GetTextX(y1, y2);
    
    var value = string(input.value);
    var sw = string_width(value);
    var sw_end = sw + 4;
    
    #region text label
    draw_set_halign(input.alignment);
    draw_set_valign(input.valignment);
    draw_text_colour(tx, ty, string(input.text), c, c, c, c, 1);
    draw_set_valign(fa_middle);
    
    if (input.validation(value, input)) {
        c = input.color;
        if (input.real_value) {
            if (!is_clamped(input.value_conversion(value), input.value_lower, input.value_upper)) {
                c = c_orange;
            }
        }
    } else {
        c = c_red;
    }
    #endregion
    
    var vtx = vx1 + 12;
    var vty = mean(vy1, vy2);
    var spacing = 12;
    
    // Drawing to the surface instead of the screen directly - everything drawn needs
    // to be minus x1 and minus y1, because suddenly we're drawing at the origin again
    #region input drawing
    input.surface = surface_rebuild(input.surface, ww, hh);
    
    surface_set_target(input.surface);
    draw_clear_alpha(input.interactive ? input.back_color : c_ltgray, 1);
    
    if (input.emphasis) {
        draw_set_font(FDefaultItalic);
    }
    
    var display_text = value + (ui_is_active(input) && (floor((current_time * 0.00125) % 2) == 0) ? "|" : "");
    if (input.multi_line) {
        // i guess you could draw this in a single-line box too, but it would be pretty cramped
        #region the "how many characters remaining" counter
        if (input.value_limit > 0) {
            var remaining = input.value_limit - string_length(value);
            var f = string_length(value) / input.value_limit;
            // hard limit on 99 for characters remaining
            if (f > 0.9 && remaining < 100) {
                var remaining_w = string_width(string(remaining));
                var remaining_h = string_height(string(remaining));
                var remaining_x = ww - 4 - remaining_w;
                var remaining_y = hh - remaining_h;
                draw_text(remaining_x, remaining_y, string(remaining));
            } else {
                var remaining_x = ww - 16;
                var remaining_y = hh - 16;
                var r = 12;
                var steps = 32;
                draw_sprite(spr_ring, 0, remaining_x, remaining_y);
                draw_primitive_begin_texture(pr_trianglefan, sprite_get_texture(spr_ring, 0));
                draw_vertex_texture_colour(remaining_x, remaining_y, 0.5, 0.5, c_ui_select, 1);
                for (var i = 0; i <= steps * f; i++) {
                    var angle = 360 / steps * i - 90;
                    draw_vertex_texture_colour(
                        clamp(remaining_x + r * dcos(angle), remaining_x - r, remaining_x + r),
                        clamp(remaining_y + r * dsin(angle), remaining_y - r, remaining_y + r),
                        clamp(0.5 + 0.5 * dcos(angle), 0, 1),
                        clamp(0.5 + 0.5 * dsin(angle), 0, 1),
                    c_ui_select, 1);
                }
                draw_primitive_end();
            }
        }
        #endregion
        
        var valign = draw_get_valign();
        draw_set_valign(fa_top);
        var sh = string_height_ext(display_text, -1, vx2 - vx1 - (vtx - vx1) * 2);
        var vty = input.GetTextY(vy1, vy2, fa_top);
        draw_text_ext_colour(vtx - vx1, min(vty - vy1, hh - spacing - sh), display_text, -1, vx2 - vx1 - (vtx - vx1) * 2, c, c, c, c, 1);
        draw_set_font(FDefault);
        if (string_length(value) == 0) {
            draw_text_colour(vtx - vx1, min(vty - vy1, hh - spacing - sh), string(input.value_default), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
        }
        draw_set_valign(valign);
    } else {
        var sw_begin = min(vtx - vx1, ww - offset - sw);
        draw_text_colour(sw_begin, vty - vy1, display_text, c, c, c, c, 1);
        sw_end = sw_begin + sw + 4;
        draw_set_font(FDefault);
        if (string_length(value) == 0) {
            draw_text_colour(vtx - vx1, vty - vy1, string(input.value_default), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
        }
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
            
            if (input.validation(value, input)) {
                var execute_value_change = (!input.require_enter && v0 != value) || (input.require_enter && Controller.press_enter);
                if (execute_value_change) {
                    if (input.real_value) {
                        execute_value_change = execute_value_change && is_clamped(input.value_conversion(value), input.value_lower, input.value_upper);
                    }
                    if (execute_value_change) {
                        input.emphasis = (input.validation == validate_string_internal_name && internal_name_get(input.value));
                        input.onvaluechange(input);
                    }
                }
            }
        }
        // activation
        var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
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
    
    draw_surface(input.surface, vx1, vy1);
    draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c_black, c_black, true);
    
    #region next and previous
    if (ui_is_active(input)) {
        if (Controller.press_tab) {
            Controller.press_tab = false;
            if (keyboard_check(vk_shift)) {
                if (input.previous) {
                    ui_activate(input.previous);
                    keyboard_string = input.previous.value;
                    return;
                }
            } else if (input.next) {
                ui_activate(input.next);
                keyboard_string = input.next.value;
                return;
            }
        }
    }
    #endregion
    
    ui_handle_dropped_files(input);
}