/// @param UIListTimeline
/// @param x
/// @param y

// this is a lot of the same stuff in ui_render_list, but with a lot of stuff that isn't relevant
// cut out - entries as text vs instances, colored entries, etc

// it's also SUPER hard-coded to work with the animation editor because i don't plan on it being
// needed anywhere else; if it is, you'll want to make a more general solution for this

var timeline = argument0;
var xx = argument1;
var yy = argument2;
var animation = timeline.root.active_animation;
var active = dialog_is_active(timeline.root);
var layer_list = timeline.root.el_layers;

var x1 = timeline.x + xx;
var y1 = timeline.y + yy;
var x2 = x1 + timeline.moment_width * timeline.moment_slots;
var y2 = y1 + timeline.height;

var y3 = y2 + timeline.slots * timeline.height;

var tx = ui_get_text_x(timeline, x1, x2);
var ty = ui_get_text_y(timeline, y1, y2);

if (animation) {
    var n = ds_list_size(animation.layers);

    if (n > 0) {
        for (var i = 0; i < min(n, timeline.slots); i++) {
            var index = i + layer_list.index;
            var ya = y2 + timeline.height * i;
            var yb = ya + timeline.height;
            var tya = mean(ya, yb);
            
            if (ds_map_exists(layer_list.selected_entries, index)) {
                var c = c_ui_select;
                draw_rectangle_colour(x1, ya, x2, yb, c, c, c, c, false);
            }
        
            var c = c_black;
            var text = "...";
            
            draw_text_colour(tx, tya, string(text), c, c, c, c, 1);
        }
    }

    var offset = (n > timeline.slots) ? 16 : 0;

    var move_direction = 0;

    if (timeline.interactive && active) {
        var inbounds = mouse_within_rectangle_determine(timeline.check_view, x1, y2, x2 - offset, y3);
        if (inbounds) {
            if (Controller.double_left) {
                script_execute(timeline.ondoubleclick, timeline);
            } else if (Controller.press_left) {
                // if this ends up having a bounds problem it's probably because the timeline is empty and
                // it's trying to access n-1 from the next line
                var mn = min(((Camera.MOUSE_Y - y2) div timeline.height) + timeline.index, n - 1);
                if ((!keyboard_check(vk_control) && !keyboard_check(vk_shift)) || !timeline.allow_multi_select) {
                    ds_map_clear(timeline.selected_entries);
                }
                if (timeline.allow_multi_select && keyboard_check(vk_shift)) {
                    if (timeline.last_index > -1) {
                        var d = clamp(mn - timeline.last_index, -1, 1);
                        for (var i = timeline.last_index; i != mn; i = i + d) {
                            if (!ds_map_exists(timeline.selected_entries, i)) {
                                ds_map_add(timeline.selected_entries, i, true);
                            }
                        }
                    }
                }
                timeline.last_index = mn;
                ds_map_add(timeline.selected_entries, mn, true);
                script_execute(timeline.onvaluechange, timeline);
            } else if (Controller.press_help) {
                //ds_stuff_help_auto(timeline);
            } else if (Controller.press_right) {
                if (timeline.allow_deselect) {
                    ui_list_deselect(timeline);
                }
            }
        
            if (mouse_wheel_up()) {
                move_direction = -1;
            } else if (mouse_wheel_down()) {
                move_direction = 1;
            }
        
            if (timeline.allow_multi_select) {
                if (keyboard_check(vk_control) && keyboard_check_pressed(ord("A"))) {
                    for (var i = 0; i < ds_list_size(timeline.entries); i++) {
                        if (!ds_map_exists(timeline.selected_entries, i)) {
                            ds_map_add(timeline.selected_entries, i, true);
                        }
                    }
                }
            }
        }
    }

    if (n > timeline.slots) {
        var sw = 16;
        var noutofrange = n - timeline.slots; // at minimum, one
        draw_rectangle_colour(x2 - sw, y2, x2, y3, c_white, c_white, c_white, c_white, false);
        draw_line(x2 - sw, y2 + sw, x2, y2 + sw);
        draw_line(x2 - sw, y3 - sw, x2, y3 - sw);
        draw_rectangle(x2 - sw, y2, x2, y3, true);
        var shalf = 32 + (y3 - y2 - 32) / n;
        var smin = y2 + sw + shalf;
        var smax = y3 - sw - shalf;
        var srange = smax - smin;
        var sy = smin + srange * timeline.index / noutofrange;
    
        var sby1 = sy - shalf;
        var sby2 = sy + shalf;
        if (timeline.interactive && active) {
            var inbounds = mouse_within_rectangle_determine(timeline.check_view, x2 - sw, sby1, x2, sby2);
            if (inbounds) {
                draw_rectangle_colour(x2 - sw + 1, sby1 + 1, x2 - 1, sby2 - 1, c_ui, c_ui, c_ui, c_ui, false);
                if (Controller.press_left) {
                    timeline.click_x = Camera.MOUSE_X;
                    timeline.click_y = Camera.MOUSE_Y;
                }
            }
            if (Controller.mouse_left) {
                if (timeline.click_y > -1) {
                    timeline.index = floor(noutofrange * clamp(Camera.MOUSE_Y - smin, 0, srange) / srange);
                }
            }
            if (Controller.release_left) {
                timeline.click_x = -1;
                timeline.click_y = -1;
            }
        }
        draw_rectangle(x2 - sw, sby1, x2, sby2, true);
        draw_line_colour(x2 - sw * 4 / 5, sy - 4, x2 - sw / 5, sy - 4, c_gray, c_gray);
        draw_line_colour(x2 - sw * 4 / 5, sy, x2 - sw / 5, sy, c_gray, c_gray);
        draw_line_colour(x2 - sw * 4 / 5, sy + 4, x2 - sw / 5, sy + 4, c_gray, c_gray);
    
        if (active) {
            var inbounds_top = mouse_within_rectangle_determine(timeline.check_view, x2 - sw, y2, x2, y2 + sw);
            var inbounds_bottom = mouse_within_rectangle_determine(timeline.check_view, x2 - sw, y3 - sw, x2, y3);
            if (inbounds_top) {
                draw_rectangle_colour(x2 - sw + 1, y2 + 1, x2 - 1, y2 + sw-1, c_ui, c_ui, c_ui, c_ui, false);
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
        draw_sprite_ext(spr_scroll_arrow, 0, x2 - sw, y3, 1, -1, 0, c_white, 1);
    }
    
    timeline.index = clamp(timeline.index + move_direction, 0, max(0, n - timeline.slots));
}

draw_rectangle(x1, y2, x2, y3, true);

for (var i = timeline.moment_index; i < timeline.moment_index + timeline.moment_slots; i++) {
    var mhx = x1 + timeline.moment_width * i + timeline.moment_width / 2;
    var mlx = x1 + timeline.moment_width * i + timeline.moment_width;
    var mhy = y1;
    draw_text(mhx, mhy, string(i));
    draw_line(mlx, y2, mlx, y3);
}