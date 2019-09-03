/// @param UIList
/// @param x
/// @param y

// this is a lot of the same code as ui_render_list which annoys me slightly, except it looks directly
// at ActiveMap.all_entities in order to minimize code duplication. (Lol!)
// as such, entries, entry_colors and entries_are_instances are not used in here

var x1 = argument0.x + argument1;
var y1 = argument0.y + argument2;
var x2 = x1 + argument0.width;
var y2 = y1 + argument0.height;

var y3 = y2 + argument0.slots * argument0.height;

var tx = ui_get_text_x(argument0, x1, x2);
var ty = ui_get_text_y(argument0, y1, y2);

draw_set_halign(argument0.alignment);
draw_set_valign(argument0.valignment);
draw_set_color(argument0.color);
draw_text(tx, ty, string(argument0.text));

var n = ds_list_size(ActiveMap.all_entities);

var active = dialog_is_active(argument0.root);

if (n == 0) {
    draw_rectangle_colour(x1, y2, x2, y2+argument0.height, c_ltgray, c_ltgray, c_ltgray, c_ltgray, false);
    ty=mean(y2, y2+argument0.height);
    draw_text(tx, ty, string(argument0.text_vacant));
} else {
    for (var i=0; i<min(n, argument0.slots); i++) {
        var index=i+argument0.index;
        var ya=y2+argument0.height*i;
        var yb=ya+argument0.height;
        var tya=mean(ya, yb);
        if (ds_map_exists(argument0.selected_entries, index)) {
            if (argument0.interactive) {
                var c=c_ui_select;
            } else {
                var c=c_ltgray;
            }
            draw_rectangle_colour(x1, ya, x2, yb, c, c, c, c, false);
        }
        
        var ent=ActiveMap.all_entities[| index];
        if (ent.static&&ent.am_solid) {
            var c=c_purple;
        } else if (ent.static) {
            var c=c_blue;
        } else if (ent.am_solid) {
            var c=c_red;
        } else {
            var c=c_black;
        }
        draw_text_colour(tx, tya, string(ent.name), c, c, c, c, 1);
    }
}

if (n>argument0.slots) {
    var offset=16;
} else {
    var offset=0;
}

var move_direction=0;

if (argument0.interactive&&active) {
    if (mouse_within_rectangle(x1, y2, x2-offset, y3)) {
        if (Controller.press_left) {
            // if this ends up having a bounds problem it's probably because the list is empty and
            // it's trying to access n-1 from the next line
            var mn=min(((Camera.MOUSE_Y-y2) div argument0.height)+argument0.index, n-1);
            if ((!keyboard_check(vk_control)&&!keyboard_check(vk_shift))||!argument0.allow_multi_select) {
                ds_map_clear(argument0.selected_entries);
            }
            if (argument0.allow_multi_select&&keyboard_check(vk_shift)) {
                if (argument0.last_index>-1) {
                    var d=clamp(mn-argument0.last_index, -1, 1);
                    for (var i=argument0.last_index; i!=mn; i=i+d) {
                        if (!ds_map_exists(argument0.selected_entries, i)) {
                            ds_map_add(argument0.selected_entries, i, true);
                        }
                    }
                }
            }
            argument0.last_index=mn;
            ds_map_add(argument0.selected_entries, mn, true);
            script_execute(argument0.onvaluechange, argument0);
        }
        
        if (mouse_wheel_up()) {
            move_direction=-1;
        } else if (mouse_wheel_down()) {
            move_direction=1;
        }
        
        if (argument0.allow_multi_select) {
            if (keyboard_check(vk_control)&&keyboard_check_pressed(ord("A"))) {
                for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++) {
                    if (!ds_map_exists(argument0.selected_entries, i)) {
                        ds_map_add(argument0.selected_entries, i, true);
                    }
                }
            }
        }
    }
}

if (n>argument0.slots) {
    var sw=16;
    var noutofrange=n-argument0.slots; // at minimum, one
    draw_rectangle_colour(x2-sw, y2, x2, y3, c_white, c_white, c_white, c_white, false);
    draw_line(x2-sw, y2+sw, x2, y2+sw);
    draw_line(x2-sw, y3-sw, x2, y3-sw);
    draw_rectangle(x2-sw, y2, x2, y3, true);
    var shalf=32+(y3-y2-32)/n;
    var smin=y2+sw+shalf;
    var smax=y3-sw-shalf;
    var srange=smax-smin;
    var sy=smin+srange*argument0.index/noutofrange;
    
    var sby1=sy-shalf;
    var sby2=sy+shalf;
    if (argument0.interactive&&active) {
        if (mouse_within_rectangle(x2-sw, sby1, x2, sby2)) {
            draw_rectangle_colour(x2-sw+1, sby1+1, x2-1, sby2-1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                argument0.click_x=Camera.MOUSE_X;
                argument0.click_y=Camera.MOUSE_Y;
            }
        }
        if (Controller.mouse_left) {
            if (argument0.click_y>-1) {
                argument0.index=floor(noutofrange*clamp(Camera.MOUSE_Y-smin, 0, srange)/srange);
            }
        }
        if (Controller.release_left) {
            argument0.click_x=-1;
            argument0.click_y=-1;
        }
    }
    draw_rectangle(x2-sw, sby1, x2, sby2, true);
    draw_line_colour(x2-sw*4/5, sy-4, x2-sw/5, sy-4, c_gray, c_gray);
    draw_line_colour(x2-sw*4/5, sy, x2-sw/5, sy, c_gray, c_gray);
    draw_line_colour(x2-sw*4/5, sy+4, x2-sw/5, sy+4, c_gray, c_gray);
    
    if (active) {
        if (mouse_within_rectangle(x2-sw, y2, x2, y2+sw)) {
            draw_rectangle_colour(x2-sw+1, y2+1, x2-1, y2+sw-1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                move_direction=-1;
            } else if (Controller.mouse_left) {
                if (control_duration_left()>0.5) {
                    move_direction=-1;
                }
            }
        } else if (mouse_within_rectangle(x2-sw, y3-sw, x2, y3)) {
            draw_rectangle_colour(x2-sw+1, y3-sw+1, x2-1, y3-1, c_ui, c_ui, c_ui, c_ui, false);
            if (Controller.press_left) {
                move_direction=1;
            } else if (Controller.mouse_left) {
                if (control_duration_left()>0.5) {
                    move_direction=1;
                }
            }
        }
    }
    draw_sprite(spr_scroll_arrow, 0, x2-sw, y2);
    draw_sprite_ext(spr_scroll_arrow, 0, x2-sw, y3, 1, -1, 0, c_white, 1);
}

draw_rectangle(x1, y2, x2, y3, true);

argument0.index = clamp(argument0.index + move_direction, 0, max(0, n-argument0.slots));