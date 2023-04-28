function ui_render_color_picker_input(picker, xx, yy) {
    var buckets = 8;            // for "not all colors" mode
    
    var x1 = picker.x + xx;
    var y1 = picker.y + yy;
    var x2 = x1 + picker.width;
    var y2 = y1 + picker.height;
    
    var tx = picker.GetTextX(x1, x2);
    var ty = picker.GetTextX(y1, y2);
    
    var value = picker.value;
    var input_active = ui_is_active(picker);
    var color_initial = value;
    var alpha_initial = picker.alpha;
    
    // this is not quite the same as ui_render_text
    draw_set_halign(picker.alignment);
    draw_set_valign(picker.valignment);
    var c = picker.color; /* the ui element color, not the value */
    draw_text_colour(tx, ty, picker.text, c, c, c, c, 1);
    
    #region text input
    var vx1 = x1 + picker.value_x1;
    var vy1 = y1 + picker.value_y1;
    var vx2 = x1 + picker.value_x2;
    var vy2 = y1 + picker.value_y2;
    
    var vtx = vx1 + 12;
    var vty = mean(vy1, vy2);
    
    if (!input_active) {
        picker.value_text = string_hex(colour_reverse(picker.value), 6);
    }
    
    c = validate_hex(picker.value_text) ? c_black : c_red;
    
    if (!picker.interactive) {
        draw_rectangle_colour(vx1 + 1, vy1 + 1, vx2 - 1, vy2 - 1, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
    }
    
    draw_rectangle(vx1, vy1, vx2, vy2, true);
    
    draw_text_ext_colour(vtx, vty, picker.value_text, -1, (vx2 - vtx), c, c, c, c, 1);
    if (string_length(picker.value_text) == 0) {
        draw_text_ext_colour(vtx, vty, "RRGGBB", -1, (vx2 - 2 * vtx), c_dkgray, c_dkgray, c_dkgray, c_dkgray, 1);
    }
    
    // becasue this is going to get called several times, and it's not going to change
    var active = picker.interactive && dialog_is_active(picker.root);
    
    if (active) {
        var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
        if (inbounds) {
            if (Controller.release_left) {
                ui_activate(picker);
            }
            Stuff.element_tooltip = picker;
        } else {
            if (Controller.press_left) {
                ui_activate(noone);
            }
        }
        
        if (input_active) {
            if (current_second % 2 == 0) {
                var bx = vtx + string_width(picker.value_text) + 4;
                draw_line_width(bx, ty - 7, bx, ty + 7, 2);
            }
            picker.value_text = keyboard_string;
            if (Controller.release_escape) {
                picker.value_text = "";
            }
            
            keyboard_string = picker.value_text;
            
            if (string_length(picker.value_text) > 6) {
                picker.value_text = string_copy(picker.value_text, 1, 6);
            }
            
            // nowadays i'd just use the pointer hack, but i'll keep this here
            // because it's the only place where the old hex function was still
            // in use - and this code is almost never used anymore anyway
            static old_hex_converter = function(str) {
                var result = 0;
                
                // special unicode values
                static ZERO = ord("0");
                static NINE = ord("9");
                static A = ord("A");
                static F = ord("F");
                
                for (var i = 1; i <= string_length(str); i++) {
                    var c = ord(string_char_at(string_upper(str), i));
                    // you could also multiply by 16 but you get more nerd points for bitshifts
                    result = result << 4;
                    // if the character is a number or letter, add the value
                    // it represents to the total
                    if (c >= ZERO && c <= NINE) {
                        result = result + (c - ZERO);
                    } else if (c >= A && c <= F) {
                        result = result + (c - A + 10);
                    // otherwise complain
                    } else {
                        throw "bad input for hex(str): " + str;
                    }
                }
                
                return result;
            };
            
            if (validate_hex(picker.value_text) && string_length(picker.value_text) == 6) {
                picker.value = colour_reverse(old_hex_converter(picker.value_text));
                
                var rr = picker.value & 0x0000ff;
                var gg = (picker.value & 0x00ff00) >> 8;
                var bb = (picker.value & 0xff0000) >> 16;
                
                switch (picker.axis_channel) {
                    case ColorChannels.R:
                        picker.axis_value = rr;
                        picker.axis_w = gg;
                        picker.axis_h = bb;
                        break;
                    case ColorChannels.G:
                        picker.axis_value = gg;
                        picker.axis_w = bb;
                        picker.axis_h = rr;
                        break;
                    case ColorChannels.B:
                        picker.axis_value = bb;
                        picker.axis_w = rr;
                        picker.axis_h = gg;
                        break;
                }
                
                picker.axis_value = picker.axis_value / 0xff;
                picker.axis_w = picker.axis_w / 0xff;
                picker.axis_h = picker.axis_h / 0xff;
            }
        }
    }
    #endregion
    
    #region color picker
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
            var c3 = colour_replace_blue(c2, 0);
            var c4 = picker.axis_value * 0xff;
            break;
        case ColorChannels.G:
            var c2 = colour_replace_green(c_white, picker.axis_value * 0xff);
            var c1 = colour_replace_blue(c2, 0);
            var c3 = colour_replace_red(c2, 0);
            var c4 = (picker.axis_value * 0xff) << 8;
            break;
        case ColorChannels.B:
            var c2 = colour_replace_blue(c_white, picker.axis_value * 0xff);
            var c1 = colour_replace_red(c2, 0);
            var c3 = colour_replace_green(c2, 0);
            var c4 = (picker.axis_value * 0xff) << 16;
            break;
    }
    
    if (active) {
        var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
        if (inbounds && Controller.press_left) {
            picker.selecting_color = true;
        }
    }
    
    if (picker.selecting_color) {
        picker.axis_w = clamp((mouse_x - vx1) / w, 0, 1);
        picker.axis_h = 1 - clamp((mouse_y - vy1) / h, 0, 1);
        picker.selecting_color = Controller.mouse_left;
    }
    
    var axis = picker.axis_value;
    var ww = picker.axis_w;
    var hh = picker.axis_h;
    
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
    
    if (!picker.all_colors) {
        shader_set(shd_basic_colors);
        shader_set_uniform_f(shader_get_uniform(shd_basic_colors, "buckets"), buckets);
    }
    
    draw_rectangle_colour(vx1, vy1, vx2, vy2, c1, c2, c3, c4, false);
    shader_reset();
    draw_rectangle(vx1, vy1, vx2, vy2, true);
    
    gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_color);
    var chx = vx1 + picker.axis_w * w;
    var chy = vy1 + (1 - picker.axis_h) * h;
    draw_sprite(spr_crosshair_mask, 0, chx, chy);
    gpu_set_blendmode(bm_normal);
    #endregion
    
    #region color axis
    vx1 = x1 + picker.axis_x;
    vy1 = y1 + picker.axis_y;
    vx2 = vx1 + picker.axis_width;
    vy2 = vy1 + picker.main_size;
    var w = vx2 - vx1;
    var h = vy2 - vy1;
    
    if (active) {
        var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
        if (inbounds && Controller.press_left) {
            picker.selecting_axis = true;
        }
    }
    
    if (picker.selecting_axis) {
        picker.axis_value = clamp((mouse_y - vy1) / h, 0, 1);
        picker.selecting_axis = Controller.mouse_left;
    }
    
    if (!picker.all_colors) {
        shader_set(shd_basic_colors);
    }
    
    static color_channels = [0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000];
    var c = color_channels[picker.axis_channel];
    draw_rectangle_colour(vx1, vy1, vx2, vy2, c_black, c_black, c, c, false);
    draw_rectangle(vx1, vy1, vx2, vy2, true);
    shader_reset();
    draw_rectangle(vx1, vy1, vx2, vy2, true);
    
    var f = min(vy1 + h * picker.axis_value, vy2 - 1);
    gpu_set_blendmode_ext(bm_inv_dest_color, bm_inv_src_color);
    draw_line_width_colour(vx1, f, vx2, f, 2, c_white, c_white);
    gpu_set_blendmode(bm_normal);
    #endregion
    
    #region output color
    vx1 = x1 + picker.output_x;
    vy1 = y1 + picker.output_y;
    vx2 = vx1 + picker.main_size;
    vy2 = vy1 + picker.output_height;
    var w = vx2 - vx1;
    var h = vy2 - vy1;
    
    draw_checkerbox(vx1, vy1, vx2 - vx1, vy2 - vy1, 2.25, 2.25);
    draw_set_alpha(picker.alpha);
    draw_rectangle_colour(vx1, vy1, vx2, vy2, picker.value, picker.value, picker.value, picker.value, false);
    draw_set_alpha(1);
    draw_rectangle(vx1, vy1, vx2, vy2, true);
    #endregion
    
    #region alpha
    if (picker.allow_alpha) {
        vx1 = x1 + picker.alpha_x;
        vy1 = y1 + picker.alpha_y;
        vx2 = vx1 + picker.main_size;
        vy2 = vy1 + picker.alpha_height;
        var w = vx2 - vx1;
        var h = vy2 - vy1;
        
        if (active) {
            var inbounds = mouse_within_rectangle(vx1, vy1, vx2, vy2);
            if (inbounds && Controller.press_left) {
                picker.selecting_alpha = true;
            }
        }
        
        if (picker.selecting_alpha) {
            picker.alpha = clamp((mouse_x - vx1) / w, 0, 1);
            picker.selecting_alpha = Controller.mouse_left;
        }
        
        draw_text(tx, mean(vy1, vy2), "A");
        draw_checkerbox(vx1, vy1, vx2 - vx1, vy2 - vy1, 2.25, 2.25);
        draw_primitive_begin(pr_trianglelist);
        draw_vertex_colour(vx1, vy1, picker.value, 0);
        draw_vertex_colour(vx2, vy1, picker.value, 1);
        draw_vertex_colour(vx2, vy2, picker.value, 1);
        draw_vertex_colour(vx2, vy2, picker.value, 1);
        draw_vertex_colour(vx1, vy2, picker.value, 0);
        draw_vertex_colour(vx1, vy1, picker.value, 0);
        draw_primitive_end();
        draw_rectangle(vx1, vy1, vx2, vy2, true);
        var f = min(vx1 + w * picker.alpha, vx2 - 1);
        draw_line_width_colour(f, vy1, f, vy2, 2, c_white, c_white);
    }
    #endregion
    
    if (color_initial != picker.value || alpha_initial != picker.alpha) {
        picker.onvaluechange(picker);
    }
    
    ui_handle_dropped_files(picker);
}