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

var tx = ui_get_text_x(list, x1, x2);
var ty = ui_get_text_y(list, y1, y2);

draw_set_halign(list.alignment);
draw_set_valign(list.valignment);
draw_set_color(list.color);
draw_text(tx, ty, string(list.text));

var n = ds_list_size(list.entries);
list.index = clamp(n - list.slots, 0, list.index);

var active = dialog_is_active(list.root);

if (n == 0) {
    draw_rectangle_colour(x1, y2, x2, y2 + list.height, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
    ty = mean(y2, y2 + list.height);
    draw_text(tx, ty, string(list.text_vacant));
} else {
    for (var i = 0; i < min(n, list.slots); i++) {
        var index = i + list.index;
        var ya = y2 + list.height * i;
        var yb = ya + list.height;
        var tya = mean(ya, yb);
        if (ds_map_exists(list.selected_entries, index)) {
            var c = list.interactive ? c_ui_select : c_ltgray;
            draw_rectangle_colour(x1, ya, x2, yb, c, c, c, c, false);
        }
        
        var c = list.colorize ? script_execute(list.render_colors, list, i) : c_black;
        var text = list.numbered ? string(index) + ". " : "";
        
        switch (list.entries_are) {
            case ListEntries.STRINGS: text = text + list.entries[| index]; break;
			case ListEntries.INSTANCES_REFID: text = text + +"<" + string_hex(list.entries[| index].REFID) + "> "; /* cascades */
            case ListEntries.INSTANCES: text = text + list.entries[| index].name; break;
            case ListEntries.GUIDS:
                var data = guid_get(list.entries[| index]);
                text = text + (data ? data.name : " (null)");
                break;
        }
        draw_text_colour(tx, tya, string(text), c, c, c, c, 1);
    }
}

var offset = (n > list.slots) ? 16 : 0;

var move_direction = 0;

if (list.interactive && active) {
    var inbounds = mouse_within_rectangle_determine(x1, y2, x2 - offset, y3, list.adjust_view);
    if (inbounds) {
        if (Controller.double_left) {
            script_execute(list.ondoubleclick, list);
        } else if (Controller.press_left) {
            // if this ends up having a bounds problem it's probably because the list is empty and
            // it's trying to access n-1 from the next line
            var mn = min(((Camera.MOUSE_Y - y2) div list.height) + list.index, n - 1);
            if ((!keyboard_check(vk_control) && !keyboard_check(vk_shift) && !list.select_toggle) || !list.allow_multi_select) {
                ds_map_clear(list.selected_entries);
            }
            if (list.allow_multi_select && keyboard_check(vk_shift)) {
                if (list.last_index > -1) {
                    var d = clamp(mn - list.last_index, -1, 1);
                    for (var i = list.last_index; i != mn; i = i + d) {
                        if (!ds_map_exists(list.selected_entries, i)) {
                            ds_map_add(list.selected_entries, i, true);
                        } else if (list.select_toggle) {
							ds_map_delete(list.selected_entries, i);
						}
                    }
                }
            } else {
				if (!ds_map_exists(list.selected_entries, mn)) {
					ds_map_add(list.selected_entries, mn, true);
				} else if (list.select_toggle) {
					ds_map_delete(list.selected_entries, mn);
				}
			}
			
            list.last_index = mn;
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
                    if (!ds_map_exists(list.selected_entries, i)) {
                        ds_map_add(list.selected_entries, i, true);
                    } else if (list.select_toggle) {
						ds_map_delete(list.selected_entries, i);
					}
                }
            }
        }
    }
}

if (n > list.slots) {
    var sw = 16;
    var noutofrange = n - list.slots; // at minimum, one
    var shalf = 32 + sqrt(n) * (y3 - y2 - 32) / n;
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
                list.click_x = Camera.MOUSE_X;
                list.click_y = Camera.MOUSE_Y;
            }
        }
        if (Controller.mouse_left) {
            if (list.click_y > -1) {
                list.index = floor(noutofrange * clamp(Camera.MOUSE_Y - smin, 0, srange) / srange);
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

draw_rectangle(x1, y2, x2, y3, true);

list.index = clamp(list.index + move_direction, 0, max(0, n - list.slots));