/// @param mode

var mode = argument0;

if (Stuff.menu.active_element) {
    return false;
}

var camera = view_get_camera(view_3d);
var cwidth = camera_get_view_width(camera);
var cheight = camera_get_view_height(camera);

var x1 = mode.x - cwidth / 2;
var y1 = mode.y - cheight / 2;
var x2 = mode.x + cwidth / 2;
var y2 = mode.y + cheight / 2;

var floor_cx = floor(((mouse_x_view + x1) / view_get_wport(view_3d)) * cwidth / TILE_WIDTH);
var floor_cy = floor(((mouse_y_view + y1) / view_get_hport(view_3d)) * cheight / TILE_HEIGHT);

// these will override everything else, but it's commented out because i dont like how it works
if (false && ds_list_size(mode.selection) && Controller.mouse_left) {
    var dx = clamp((mouse_x - Controller.mouse_x_previous) div 4, -1, 1);
    var dy = clamp((mouse_y - Controller.mouse_y_previous) div 4, -1, 1);
    
    switch (Stuff.setting_mouse_drag_behavior) {
        case 1:             // translate
            var sel = selection_all();
            for (var i = 0; i < ds_list_size(sel); i++) {
                var thing = sel[| i];
                map_move_thing(thing, thing.xx + dx, thing.yy + dy, thing.zz);
            }
            ds_list_destroy(sel);
            for (var i = 0; i < ds_list_size(mode.selection); i++) {
                var sel = mode.selection[| i];
                script_execute(sel.onmove, sel, dx, dy, 0);
            }
            return 0;
        case 2:             // offset
            return 0;
        case 3:             // rotate
            return 0;
        case 4:             // scale
            return 0;
    }
}

if (Controller.press_left) {
    if (ds_list_size(mode.selection) < MAX_SELECTION_COUNT) {
        if (!keyboard_check(Controller.input_selection_add) && !Stuff.setting_selection_addition) {
            selection_clear();
        }
        switch (Stuff.setting_selection_mode) {
            case SelectionModes.SINGLE: var stype = SelectionSingle; break;
            case SelectionModes.RECTANGLE: var stype = SelectionRectangle; break;
            case SelectionModes.CIRCLE: var stype = SelectionCircle; break;
        }
        
        var tz = mode.under_cursor ? mode.under_cursor.zz : 0;
        
        mode.last_selection = instance_create_depth(0, 0, 0, stype);
        ds_list_add(mode.selection, mode.last_selection);
        script_execute(mode.last_selection.onmousedown, mode.last_selection, floor_cx, floor_cy, tz);
    }
}
if (Controller.mouse_left) {
    if (mode.last_selection) {
        script_execute(mode.last_selection.onmousedrag, mode.last_selection, floor_cx + 1, floor_cy + 1);
    }
}
if (Controller.release_left) {
    // selections of zero area are just deleted outright
    if (mode.last_selection) {
        if (script_execute(mode.last_selection.area, mode.last_selection) == 0) {
            instance_activate_object(mode.last_selection);
            instance_destroy(mode.last_selection);
            ds_list_pop(mode.selection);
            mode.last_selection = noone;
            sa_process_selection();
        }
    }
}

if (keyboard_check_pressed(vk_space)) {
    sa_fill();
}
if (keyboard_check_pressed(vk_delete)) {
    sa_delete();
}

// move the camera

if (!keyboard_check(vk_control)) {
    var mspd = get_camera_speed(100);
    var xspeed = 0;
    var yspeed = 0;
    
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        yspeed = yspeed - mspd;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        yspeed = yspeed + mspd;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed = xspeed - mspd;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed = xspeed + mspd;
    }
    if (CONTORL_3D_LOOK) {
        var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) / 2;
        var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) / 2;
        var dx = (Stuff.MOUSE_X - camera_cx) / 16;
        var dy = (Stuff.MOUSE_Y - camera_cy) / 16;
        window_mouse_set(camera_cx, camera_cy);
    }
    
    mode.x += xspeed;
    mode.y += yspeed;
}

if (Controller.press_right) {
    Controller.press_right = false;
    // if there is no selection, select the single square under the cursor. Otherwise you might
    // want to do operations on large swaths of entities, so don't clear it or anythign like that.
    
    if (selection_empty()) {
        var tz = mode.under_cursor ? mode.under_cursor.zz : 0;
        mode.last_selection = instance_create_depth(0, 0, 0, SelectionSingle);
        ds_list_add(mode.selection, mode.last_selection);
        script_execute(mode.last_selection.onmousedown, mode.last_selection, floor_cx, floor_cy, tz);
    }
    
    var menu = Stuff.menu.menu_right_click;
    menu_activate_extra(menu);
    menu.x = Stuff.MOUSE_X;
    menu.y = Stuff.MOUSE_Y;
}