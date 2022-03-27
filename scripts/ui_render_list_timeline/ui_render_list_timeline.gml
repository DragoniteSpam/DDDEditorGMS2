/// @param UIListTimeline
/// @param x
/// @param y
function ui_render_list_timeline(argument0, argument1, argument2) {

    // this is a lot of the same stuff in ui_render_list, but with a lot of stuff that
    // isn't relevant cut out - entries as text vs instances, colored entries, etc

    // it's also SUPER hard-coded to work with the animation editor because i don't
    // plan on it being needed anywhere else; if it is, you'll want to make a more
    // general solution for this

    var timeline = argument0;
    var xx = argument1;
    var yy = argument2;

    var animation = timeline.root.active_animation;
    var active = dialog_is_active(timeline.root);
    var layer_list = timeline.root.el_layers;

    if (animation) {
        // this feels really gross but it works as a way to make sure the play head never goes one
        // moment too far, since it floor()s the value before doing stuff with it
        timeline.playing_moment = min(timeline.playing_moment, animation.moments - 0.0001);
    }

    // update the play head first

    if (animation && timeline.playing) {
        var old_moment = timeline.playing_moment;
        var dt_scale = animation.frames_per_second / game_get_speed(gamespeed_fps);
        timeline.playing_moment = timeline.playing_moment + dt_scale;
        timeline.playing_moment = timeline.playing_moment % animation.moments;
        var fmoment = floor(timeline.playing_moment);
        if (fmoment >= timeline.moment_index + timeline.moment_slots - 1) {
            timeline.moment_index = min(animation.moments - timeline.moment_slots, fmoment);
        } else if (fmoment < timeline.moment_index) {
            timeline.moment_index = fmoment;
        }
        if (!timeline.playing_loop && old_moment > timeline.playing_moment) {
            timeline.playing = false;
        }
    }

    // now actually draw it

    var x1 = timeline.x + xx;
    var y1 = timeline.y + yy;
    var x2 = x1 + timeline.moment_width * timeline.moment_slots;
    var y2 = y1 + timeline.height;

    var y3 = y2 + timeline.slots * timeline.height;

    var tx = timeline.GetTextX(x1, x2);
    var ty = timeline.GetTextX(y1, y2);

    if (animation) {
        var n = array_length(animation.layers);

        if (n > 0) {
            var c = c_ui_select;
            // layer list's selected entries
            for (var i = 0; i < min(n, timeline.slots); i++) {
                var index = i + layer_list.index;
                var ya = y2 + timeline.height * i;
                var yb = ya + timeline.height;
                var tya = mean(ya, yb);
            
                if (ui_list_is_selected(layer_list, index)) {
                    draw_rectangle_colour(x1, ya, x2, yb, c, c, c, c, false);
                }
            }
        
            // if the selection is out of bounds (layers deleted, etc) reset the selection
            if (timeline.selected_layer >= n) {
                timeline.selected_layer = -1;
            }
            if (timeline.selected_moment > animation.moments) {
                timeline.selected_moment = -1;
            }
        
            // moments that are on exact seconds should be highlighted
            var moment_start = timeline.moment_index;
            var moment_end = min(timeline.moment_index + timeline.moment_slots, animation.moments);
        
            if (animation) {
                var c_interval = colour_fade(c_ui_select);
                for (var i = moment_start; i < moment_end; i++) {
                    if (i % animation.frames_per_second == 0) {
                        var kfx1 = x1 + timeline.moment_width * (i - timeline.moment_index);
                        var kfx2 = x1 + timeline.moment_width * (i - timeline.moment_index + 1);
                        draw_rectangle_colour(kfx1, y2, kfx2, y3, c_interval, c_interval, c_interval, c_interval, false);
                    }
                }
            }
        
            // draw the keyframe selection
            if (is_clamped(timeline.selected_layer, layer_list.index, layer_list.index + layer_list.slots - 1)) {
                if (is_clamped(timeline.selected_moment, timeline.moment_index, min(timeline.moment_index + timeline.moment_slots - 1, animation.moments))) {
                    var mlx = x1 + timeline.moment_width * (timeline.selected_moment - timeline.moment_index + 0.5);
                    var mly = y2 + timeline.height * (timeline.selected_layer - layer_list.index + 0.5);
                    draw_sprite(spr_timeline_keyframe_selected, 0, mlx, mly);
                }
            }
        
            // draw the keyframes
            for (var i = 0; i < min(n, timeline.slots); i++) {
                var index = i + layer_list.index;
            
                // check that the timeline layer is inbounds - the layer list will resize itself later,
                // but we need to check here just to be safe
                if (index < array_length(timeline.root.active_animation.layers)) {
                    var timeline_layer = timeline.root.active_animation.layers[index];
                
                    for (var j = moment_start; j < moment_end; j++) {
                        var keyframe = timeline_layer.keyframes[j];
                        if (keyframe) {
                            var kfx = x1 + timeline.moment_width * (keyframe.moment - timeline.moment_index + 0.5);
                            var kfy = y2 + timeline.height * (i + 0.5);
                        
                            if (keyframe.HasTween()) {
                                var next = animation.GetNextKeyframe(index, j);
                                var kfnx = next ? x1 + timeline.moment_width * (next.moment - timeline.moment_index + 0.5) : x2;
                                draw_line_width_colour(kfx, kfy, kfnx, kfy, 2, c_blue, c_blue);
                            }
                        
                            draw_sprite(spr_timeline_keyframe, 0, kfx, kfy);
                        }
                    }
                }
            }
        }

        var offset = (n > timeline.slots) ? 16 : 0;

        var move_direction = 0;
        var move_horizontal_direction = 0;

        if (timeline.interactive && active) {
            var inbounds = mouse_within_rectangle(x1, y2, x2, y3);
            if (inbounds) {
                // double-left not used, that's to be handled by oninteract instead now
                if (Controller.mouse_left) {
                    var mx = min(((mouse_x - x1) div timeline.moment_width) + timeline.moment_index, animation.moments - 1);
                    var my = min(((mouse_y - y2) div timeline.height) + layer_list.index, n - 1);
                
                    timeline.selected_moment = mx;
                    timeline.selected_layer = my;
                    timeline.playing_moment = mx;
                
                    ui_list_deselect(layer_list);
                    ui_list_select(layer_list, my);
                
                    timeline.onvaluechange(timeline);
                } else if (Controller.press_right) {
                    if (timeline.allow_deselect) {
                        timeline.selected_moment = -1;
                        timeline.selected_layer = -1;
                    }
                }
            
                // oninteract doesn't care if the mouse is inbounds so if you're going to run any code that
                // might break in special circumstances you're going to need to check for that - but it might
                // depend on the selected moment / layer being set, so we'll execute it at the end here
                timeline.oninteract(timeline, xx, yy);
            
                var control = keyboard_check(vk_shift);
                if (mouse_wheel_up()) {
                    if (control) {
                        move_horizontal_direction = -1;
                    } else {
                        move_direction = -1;
                    }
                } else if (mouse_wheel_down()) {
                    if (control) {
                        move_horizontal_direction = 1;
                    } else {
                        move_direction = 1;
                    }
                }
            }
        }

        if (animation.moments > timeline.moment_slots) {
            // the horizontal slider goes below the list in this case, because there might be important
            // information in the last row of the list that gets obscured - the normal lists should
            // probably employ this strategy as well, but i think it's less of a big deal there because
            // the information in them will typically be left-aligned
            var sw = 16;
            var noutofrange = animation.moments - timeline.moment_slots; // at minimum, one
            var y4 = y3 + sw;
            var shalf = sw * 2 + sqrt(animation.moments) * (x2 - x1 - sw * 2) / animation.moments;
            var smin = x1 + sw + shalf;
            var smax = x2 - sw - shalf;
            var srange = smax - smin;
            var sx = smin + srange * timeline.moment_index / noutofrange;
            draw_rectangle_colour(x1, y3, x2, y4, c_white, c_white, c_white, c_white, false);
            draw_line(x1 + sw, y3, x1 + sw, y4);
            draw_line(x2 - sw, y3, x2 - sw, y4);
            draw_rectangle(x1, y3, x2, y4, true);
        
            var sbx1 = sx - shalf;
            var sbx2 = sx + shalf;
            if (timeline.interactive && active) {
                var inbounds = mouse_within_rectangle(sbx1, y3, sbx2, y4);
                if (inbounds) {
                    draw_rectangle_colour(sbx1 + 1, y3 + 1, sbx2 - 1, y4 - 1, c_ui, c_ui, c_ui, c_ui, false);
                    if (Controller.press_left) {
                        timeline.click_x = mouse_x;
                        timeline.click_y = mouse_y;
                    }
                }
                if (Controller.mouse_left) {
                    if (timeline.click_y > -1) {
                        timeline.moment_index = floor(noutofrange * clamp(mouse_x - smin, 0, srange) / srange);
                    }
                }
                if (Controller.release_left) {
                    timeline.click_x = -1;
                    timeline.click_y = -1;
                }
            }
        
            draw_rectangle(sbx1, y3, sbx2, y4, true);
            draw_line_colour(sx - 4, y3 + sw / 5, sx - 4, y3 + sw * 4 / 5, c_gray, c_gray);
            draw_line_colour(sx, y3 + sw / 5, sx, y3 + sw * 4 / 5, c_gray, c_gray);
            draw_line_colour(sx + 4, y3 + sw / 5, sx + 4, y3 + sw * 4 / 5, c_gray, c_gray);
        
            if (active) {
                var inbounds_top = mouse_within_rectangle(x1, y3, x1 + sw, y4);
                var inbounds_bottom = mouse_within_rectangle(x2 - sw, y3, x2, y4);
                if (inbounds_top) {
                    draw_rectangle_colour(x1 + 1, y3 + 1, x1 + sw - 1, y4 - 1, c_ui, c_ui, c_ui, c_ui, false);
                    if (Controller.press_left) {
                        move_horizontal_direction = -1;
                    } else if (Controller.mouse_left) {
                        if (control_duration_left() > 0.5) {
                            move_horizontal_direction = -1;
                        }
                    }
                } else if (inbounds_bottom) {
                    draw_rectangle_colour(x2 - sw + 1, y3 + 1, x2 - 1, y4 - 1, c_ui, c_ui, c_ui, c_ui, false);
                    if (Controller.press_left) {
                        move_horizontal_direction = 1;
                    } else if (Controller.mouse_left) {
                        if (control_duration_left() > 0.5) {
                            move_horizontal_direction = 1;
                        }
                    }
                }
            }
        
            draw_sprite(spr_scroll_arrow, 2, x1, y3);
            draw_sprite(spr_scroll_arrow, 3, x2 - sw, y3);
        }
    
        layer_list.index = clamp(layer_list.index + move_direction, 0, max(0, n - layer_list.slots));
        timeline.moment_index = clamp(timeline.moment_index + move_horizontal_direction, 0, max(0, animation.moments - timeline.moment_slots));
    }

    // draw the grid over everything else
    draw_rectangle(x1, y2, x2, y3, true);
    draw_set_halign(fa_center);
    for (var i = 0; i < timeline.moment_slots; i++) {
        var index = i + timeline.moment_index;
        if (animation && index > animation.moments - 1) {
            break;
        }
        var mhx = x1 + timeline.moment_width * (i + 0.5);
        var mlx = x1 + timeline.moment_width * (i + 1);
        var mhy = ty;
        draw_text(mhx, mhy, string(index));
        draw_line(mlx, y2, mlx, y3);
    }
    draw_set_halign(fa_left);

    if (is_clamped(timeline.playing_moment, timeline.moment_index, timeline.moment_index + timeline.moment_slots)) {
        var fmoment = floor(timeline.playing_moment);
        var phx = x1 + (fmoment - timeline.moment_index + 0.5) * timeline.moment_width;
        draw_line_width_colour(phx, y2 - 6, phx, y3, 2, c_red, c_red);
    }

    var sw = sprite_get_width(spr_play_controls);
    var sh = sprite_get_height(spr_play_controls);
    var spacing = 16;
    var c_greenish = merge_colour(c_lime, c_white, 0.5);
    var c_play = timeline.playing ? c_greenish : c_white;
    var c_loop = timeline.playing_loop ? c_greenish : c_white;

    draw_sprite_ext(spr_play_controls, 0, x1 + spacing, y3 + spacing, 1, 1, 0, c_play, 1);
    draw_sprite_ext(spr_play_controls, 1, x1 + spacing + sw, y3 + spacing, 1, 1, 0, c_white, 1);
    draw_sprite_ext(spr_play_controls, 2, x1 + spacing + sw * 2, y3 + spacing, 1, 1, 0, c_white, 1);
    draw_sprite_ext(spr_play_controls, 3, x1 + spacing + sw * 3, y3 + spacing, 1, 1, 0, c_loop, 1);

    var inbounds_play = mouse_within_rectangle(x1 + spacing, y3 + spacing, x1 + spacing + sw, y3 + spacing + sh);
    var inbounds_pause = mouse_within_rectangle(x1 + spacing + sw, y3 + spacing, x1 + spacing + sw * 2, y3 + spacing + sh);
    var inbounds_stop = mouse_within_rectangle(x1 + spacing + sw * 2, y3 + spacing, x1 + spacing + sw * 3, y3 + spacing + sh);
    var inbounds_loop = mouse_within_rectangle(x1 + spacing + sw * 3, y3 + spacing, x1 + spacing + sw * 4, y3 + spacing + sh);

    if (inbounds_play) {
        c_play = timeline.playing ? merge_colour(c_greenish, c_ltgray, 0.5) : c_ltgray;
        draw_sprite_ext(spr_play_controls, 0, x1 + spacing, y3 + spacing, 1, 1, 0, c_play, 1);
        if (Controller.release_left && animation) {
            timeline.playing = true;
        }
    } else if (inbounds_pause) {
        draw_sprite_ext(spr_play_controls, 1, x1 + spacing + sw, y3 + spacing, 1, 1, 0, c_ltgray, 1);
        if (Controller.release_left) {
            timeline.playing = false;
        }
    } else if (inbounds_stop) {
        draw_sprite_ext(spr_play_controls, 2, x1 + spacing + sw * 2, y3 + spacing, 1, 1, 0, c_ltgray, 1);
        if (Controller.release_left) {
            timeline.playing = false;
            timeline.playing_moment = 0;
            timeline.moment_index = 0;
        }
    } else if (inbounds_loop) {
        c_loop = timeline.playing_loop ? merge_colour(c_greenish, c_ltgray, 0.5) : c_ltgray;
        draw_sprite_ext(spr_play_controls, 3, x1 + spacing + sw * 3, y3 + spacing, 1, 1, 0, c_loop, 1);
        if (Controller.release_left) {
            timeline.playing_loop = !timeline.playing_loop;
        }
    }

    if (dialog_is_active(timeline.root)) {
        if (keyboard_check_pressed(vk_space) && animation) {
            timeline.playing = !timeline.playing;
        }
    
        if (keyboard_check_pressed(vk_left) && animation) {
            timeline.playing = false;
            timeline.playing_moment = (--timeline.playing_moment + animation.moments) % animation.moments;
        }
    
        if (keyboard_check_pressed(vk_right) && animation) {
            timeline.playing = false;
            timeline.playing_moment = ++timeline.playing_moment % animation.moments;
        }
    
        if (Controller.press_enter) {
            timeline.playing = false;
            timeline.playing_moment = 0;
            timeline.moment_index = 0;
        }
    }

    ui_handle_dropped_files(timeline);


}
