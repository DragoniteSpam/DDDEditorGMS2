/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var x1 = list.x + xx;
var y1 = list.y + yy;
var x2 = x1 + list.width;
var y2 = y1 + list.height;
var y3 = y2 + list.slots * list.height;
var ww = x2 - x1;
var hh = y3 - y2;

var tx = ui_get_text_x(list, x1, x2);
var ty = ui_get_text_y(list, y1, y2);

#region stuff around the list
draw_set_halign(list.alignment);
draw_set_valign(list.valignment);
draw_set_color(list.color);

if (string_length(list.tooltip) > 0) {
    var spr_xoffset = sprite_get_xoffset(spr_help);
    var spr_yoffset = sprite_get_yoffset(spr_help);
    var spr_width = sprite_get_width(spr_help);
    var spr_height = sprite_get_height(spr_help);
    var txoffset = spr_width;
    var inbounds = mouse_within_rectangle_determine(tx - spr_xoffset, ty - spr_yoffset, tx - spr_xoffset + spr_width, ty - spr_yoffset + spr_height, list.adjust_view);
    draw_sprite(spr_help, inbounds ? 1 : 0, tx, ty);
    if (inbounds) {
        Stuff.element_tooltip = list;
    }
} else {
    var txoffset = 0;
}
draw_text(tx + txoffset, ty, string(list.text));
#endregion

// Drawing to the surface instead of the screen directly - everything drawn needs
// to be minus x1 and minus y1, because suddenly we're drawing at the origin again
#region list drawing
if (surface_exists(list.surface) && (surface_get_width(list.surface) != ww || surface_get_height(list.surface) != hh)) {
    surface_free(list.surface);
}

if (!surface_exists(list.surface)) {
    list.surface = surface_create(ww, hh);
}

surface_set_target(list.surface);
draw_clear_alpha(list.interactive ? c_white : c_ltgray, 1);

var n = (list.entries + 1) ? ds_list_size(list.entries) : 0;
list.index = clamp(n - list.slots, 0, list.index);

var active = dialog_is_active(list.root);

if (n == 0) {
    draw_rectangle_colour(0, 0, x2 - x1, y2 + list.height - y2, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
    ty = mean(y2, y2 + list.height);
    draw_text(tx - x1, ty - y2, string(list.text_vacant));
} else {
    for (var i = 0; i < min(n, list.slots); i++) {
        var index = i + list.index;
        var ya = y2 + list.height * i;
        var yb = ya + list.height;
        var tya = mean(ya, yb);
        if (ui_list_is_selected(list, index)) {
            var c = list.interactive ? c_ui_select : c_ltgray;
            draw_rectangle_colour(0, ya - y2, x2 - x1, yb - y2, c, c, c, c, false);
        }
        
        var c = list.colorize ? script_execute(list.render_colors, list, index) : c_black;
        var text = list.numbered ? string(index) + ". " : "";
        
        switch (list.entries_are) {
            // i resisted casting to string for a while because i wanted them to be
            // actual strings, but now that lists are allowed to reference other ds_lists
            // which may not necessarily contain strings that's not really a viable option
            case ListEntries.STRINGS: text += string(list.entries[| index]); break;
            case ListEntries.INSTANCES: text += list.entries[| index].name; break;
            case ListEntries.GUIDS:
                var data = guid_get(list.entries[| index]);
                text = text + (data ? data.name : " (null)");
                break;
            case ListEntries.REFIDS:
                var data = refid_get(list.entries[| index]);
                text = text + (data ? data.name : " (null)");
                break;
            case ListEntries.INSTANCES_REFID:
                text += "<" + string_hex(list.entries[| index].REFID) + "> " + list.entries[| index].name;
                break;
            case ListEntries.SCRIPT: text = text + script_execute(list.evaluate_text, list, index); break;
        }
        draw_text_colour(tx - x1, tya - y2, string(text), c, c, c, c, 1);
    }
}
surface_reset_target();
#endregion

draw_surface(list.surface, x1, y2);
var offset = (n > list.slots) ? 16 : 0;

var move_direction = 0;

if (list.interactive && active) {
    var inbounds = mouse_within_rectangle_determine(x1, y2, x2 - offset, y3, list.adjust_view);
    if (inbounds) {
        if (Controller.mouse_middle) {
            script_execute(list.onmiddleclick, list);
        } else if (Controller.double_left) {
            script_execute(list.ondoubleclick, list);
        } else if (Controller.press_left) {
            // if this ends up having a bounds problem it's probably because the list is empty and
            // it's trying to access n-1 from the next line
            var mn = min(((Stuff.MOUSE_Y - y2) div list.height) + list.index, n - 1);
            // deselect the list if that's what yo uwould expect to happen
            if (!list.auto_multi_select) {
                if ((!keyboard_check(vk_control) && !keyboard_check(vk_shift) && !list.select_toggle) || !list.allow_multi_select) {
                    ui_list_deselect(list);
                }
            }
            // toggle selection over a range
            if (list.allow_multi_select && keyboard_check(vk_shift)) {
                if (list.last_index > -1) {
                    var d = clamp(mn - list.last_index, -1, 1);
                    for (var i = list.last_index; i != mn; i = i + d) {
                        if (!ui_list_is_selected(list, i)) {
                            ui_list_select(list, i);
                        } else if (list.select_toggle && list.allow_deselect) {
                            ds_map_delete(list.selected_entries, i);
                        }
                    }
                }
            // toggle single selections
            } else {
                if (!ui_list_is_selected(list, mn)) {
                    ds_map_add(list.selected_entries, mn, true);
                } else if (list.select_toggle && list.allow_deselect) {
                    ds_map_delete(list.selected_entries, mn);
                }
            }
            
            list.last_index = mn;
            ui_activate(list);
            script_execute(list.onvaluechange, list);
        } else if (Controller.press_right) {
            if (list.allow_deselect) {
                ui_list_deselect(list);
                script_execute(list.onvaluechange, list);
            }
        }
        
        if (mouse_wheel_up()) {
            move_direction = -1;
        } else if (mouse_wheel_down()) {
            move_direction = 1;
        }
        
        if (list.allow_multi_select) {
            if (keyboard_check(vk_control) && keyboard_check_pressed(ord("A"))) {
                for (var i = 0; i < ds_list_size(list.entries); i++) {
                    if (!ui_list_is_selected(list, i)) {
                        ui_list_select(list, i);
                    } else if (list.select_toggle) {
                        ds_map_delete(list.selected_entries, i);
                    }
                }
            }
        }
    }
}

#region slider
if (n > list.slots) {
    var sw = 16;
    var noutofrange = n - list.slots; // at minimum, one
    // the minimum slider height will never be below 20, but it'll scale up for longer lists;
    // otherwise it's simply proportional to the fraction of the entries that are visible in the list
    var shalf = max(20 + 20 * log10(list.slots), (y3 - y2 - sw * 2) * list.slots / n) / 2;
    var smin = y2 + sw + shalf;
    var smax = y3 - sw - shalf;
    var srange = smax - smin;
    var sy = smin + srange * list.index / noutofrange;
    draw_rectangle_colour(x2 - sw, y2, x2, y3, c_white, c_white, c_white, c_white, false);
    draw_line(x2 - sw, y2 + sw, x2, y2 + sw);
    draw_line(x2 - sw, y3 - sw, x2, y3 - sw);
    draw_rectangle(x2 - sw, y2, x2, y3, true);
    
    var sby1 = sy - shalf;
    var sby2 = sy + shalf;
    if (list.interactive && active) {
        var inbounds = mouse_within_rectangle_determine(x2 - sw, sby1, x2, sby2, list.adjust_view);
        if (inbounds) {
            draw_rectangle_colour(x2 - sw + 1, sby1 + 1, x2 - 1, sby2 - 1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                list.click_x = Stuff.MOUSE_X;
                list.click_y = Stuff.MOUSE_Y;
            }
        }
        if (Controller.mouse_left) {
            if (list.click_y > -1) {
                list.index = floor(noutofrange * clamp(Stuff.MOUSE_Y - smin, 0, srange) / srange);
            }
        }
        if (Controller.release_left) {
            list.click_x = -1;
            list.click_y = -1;
        }
    }
    draw_rectangle(x2 - sw, sby1, x2, sby2, true);
    draw_line_colour(x2 - sw * 4 / 5, sy - 4, x2 - sw / 5, sy - 4, c_gray, c_gray);
    draw_line_colour(x2 - sw * 4 / 5, sy, x2 - sw / 5, sy, c_gray, c_gray);
    draw_line_colour(x2 - sw * 4 / 5, sy + 4, x2 - sw / 5, sy + 4, c_gray, c_gray);
    
    if (active) {
        var inbounds_top = mouse_within_rectangle_determine(x2 - sw, y2, x2, y2 + sw, list.adjust_view);
        var inbounds_bottom = mouse_within_rectangle_determine(x2 - sw, y3 - sw, x2, y3, list.adjust_view);
        if (inbounds_top) {
            draw_rectangle_colour(x2 - sw + 1, y2 + 1, x2 - 1, y2 + sw - 1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                move_direction = -1;
            } else if (Controller.mouse_left) {
                if (control_duration_left() > 0.5) {
                    move_direction = -1;
                }
            }
        } else if (inbounds_bottom) {
            draw_rectangle_colour(x2 - sw + 1, y3 - sw + 1, x2 - 1, y3 - 1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                move_direction = 1;
            } else if (Controller.mouse_left) {
                if (control_duration_left() > 0.5) {
                    move_direction = 1;
                }
            }
        }
    }
    draw_sprite(spr_scroll_arrow, 0, x2 - sw, y2);
    draw_sprite(spr_scroll_arrow, 1, x2 - sw, y3 - sw);
}
#endregion

draw_rectangle(x1, y2, x2, y3, true);

list.index = clamp(list.index + move_direction, 0, max(0, n - list.slots));