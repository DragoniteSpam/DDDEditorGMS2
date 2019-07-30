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
        var c = c_ui_select;
        // layer list's selected entries
        for (var i = 0; i < min(n, timeline.slots); i++) {
            var index = i + layer_list.index;
            var ya = y2 + timeline.height * i;
            var yb = ya + timeline.height;
            var tya = mean(ya, yb);
            
            if (ds_map_exists(layer_list.selected_entries, index)) {
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
        
        // draw the keyframe selection
        if (is_clamped(timeline.selected_moment, timeline.moment_index, timeline.moment_index + timeline.moment_slots - 1)) {
            draw_set_alpha(0.5);
            var mlx1 = x1 + timeline.moment_width * (timeline.selected_moment - timeline.moment_index);
            var mlx2 = x1 + timeline.moment_width * (timeline.selected_moment - timeline.moment_index + 1);
            draw_rectangle_colour(mlx1, y2, mlx2, y3, c, c, c, c, false);
            draw_set_alpha(1);
        }
        
        if (is_clamped(timeline.selected_layer, layer_list.index, layer_list.index + layer_list.slots - 1)) {
            if (is_clamped(timeline.selected_moment, timeline.moment_index, timeline.moment_index + timeline.moment_slots - 1)) {
                var mlx = x1 + timeline.moment_width * (timeline.selected_moment - timeline.moment_index + 0.5);
                var mly = y2 + timeline.height * (timeline.selected_layer - layer_list.index + 0.5);
                draw_sprite(spr_timeline_keyframe_selected, 0, mlx, mly);
            }
        }
        
        // draw the keyframes
        var moment_start = timeline.moment_index;
        var moment_end = timeline.moment_index + timeline.moment_slots;
        
        for (var i = 0; i < min(n, timeline.slots); i++) {
            var index = i + layer_list.index;
            
            // check that the timeline layer is inbounds - the layer list will resize itself later,
            // but we need to check here just to be safe
            if (index < ds_list_size(timeline.root.active_animation.layers)) {
                var timeline_layer = timeline.root.active_animation.layers[| index];
                
                for (var j = moment_start; j < moment_end; j++) {
                    var keyframe = timeline_layer.keyframes[| j];
                    if (keyframe) {
                        var kfx = x1 + timeline.moment_width * (keyframe.moment - timeline.moment_index + 0.5);
                        var kfy = y2 + timeline.height * (i + 0.5);
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
        var inbounds = mouse_within_rectangle_determine(timeline.check_view, x1, y2, x2, y3);
        if (inbounds) {
            // double-left not used, that's to be handled by oninteract instead now
            if (Controller.press_left) {
                var mx = min(((Camera.MOUSE_X - x1) div timeline.moment_width) + timeline.moment_index, animation.moments - 1);
                var my = min(((Camera.MOUSE_Y - y2) div timeline.height) + layer_list.index, n - 1);
                
                timeline.selected_moment = mx;
                timeline.selected_layer = my;
                
                ui_list_deselect(layer_list);
                ds_map_add(layer_list.selected_entries, my, true);
                
                script_execute(timeline.onvaluechange, timeline);
            } else if (Controller.press_help) {
                //ds_stuff_help_auto(timeline);
            } else if (Controller.press_right) {
                if (timeline.allow_deselect) {
                    timeline.selected_moment = -1;
                    timeline.selected_layer = -1;
                }
            }
            
            // oninteract doesn't care if the mouse is inbounds so if you're going to run any code that
            // might break in special circumstances you're going to need to check for that - but it might
            // depend on the selected moment / layer being set, so we'll execute it at the end here
            script_execute(timeline.oninteract, timeline, xx, yy);
            
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
            var inbounds = mouse_within_rectangle_determine(timeline.check_view, sbx1, y3, sbx2, y4);
            if (inbounds) {
                draw_rectangle_colour(sbx1 + 1, y3 + 1, sbx2 - 1, y4 - 1, c_ui, c_ui, c_ui, c_ui, false);
                if (Controller.press_left) {
                    timeline.click_x = Camera.MOUSE_X;
                    timeline.click_y = Camera.MOUSE_Y;
                }
            }
            if (Controller.mouse_left) {
                if (timeline.click_y > -1) {
                    timeline.moment_index = floor(noutofrange * clamp(Camera.MOUSE_X - smin, 0, srange) / srange);
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
            var inbounds_top = mouse_within_rectangle_determine(timeline.check_view, x1, y3, x1 + sw, y4);
            var inbounds_bottom = mouse_within_rectangle_determine(timeline.check_view, x2 - sw, y3, x2, y4);
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

for (var i = 0; i < timeline.moment_slots; i++) {
    var mhx = x1 + timeline.moment_width * (i + 0.5);
    var mlx = x1 + timeline.moment_width * (i + 1);
    var mhy = ty;
    draw_text(mhx, mhy, string(i + timeline.moment_index));
    draw_line(mlx, y2, mlx, y3);
}

var sw = sprite_get_width(spr_play_controls);
var sh = sprite_get_height(spr_play_controls);
var spacing = 16;

draw_sprite_ext(spr_play_controls, 0, x1 + spacing, y3 + spacing, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_play_controls, 1, x1 + spacing + sw, y3 + spacing, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_play_controls, 2, x1 + spacing + sw * 2, y3 + spacing, 1, 1, 0, c_white, 1);

if (animation) {
    var inbounds_play = mouse_within_rectangle_determine(timeline.check_view, x1 + spacing, y3 + spacing, x1 + spacing + sw, y3 + spacing + sh);
    var inbounds_pause = mouse_within_rectangle_determine(timeline.check_view, x1 + spacing + sw, y3 + spacing, x1 + spacing + sw * 2, y3 + spacing + sh);
    var inbounds_stop = mouse_within_rectangle_determine(timeline.check_view, x1 + spacing + sw * 2, y3 + spacing, x1 + spacing + sw * 3, y3 + spacing + sh);
    if (inbounds_play) {
        
    } else if (inbounds_pause) {
        
    } else if (inbounds_stop) {
        
    }
}