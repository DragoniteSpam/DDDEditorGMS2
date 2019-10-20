if (Camera.menu.active_element) {
	return false;
}

var camera = view_get_camera(view_current);
var cwidth = camera_get_view_width(camera);
var cheight = camera_get_view_height(camera);

var x1 = x - cwidth / 2;
var y1 = y - cheight / 2;
var x2 = x + cwidth / 2;
var y2 = y + cheight / 2;

var floor_cx = floor(((mouse_x_view + x1) / view_get_wport(view_current)) * cwidth / TILE_WIDTH);
var floor_cy = floor(((mouse_y_view + y1) / view_get_hport(view_current)) * cheight / TILE_HEIGHT);

// these will override everything else, but it's commented out because i dont like how it works
if (false && ds_list_size(selection) && Controller.mouse_left) {
    var dx = clamp((mouse_x - Controller.mouse_x_previous) div 4, -1, 1);
    var dy = clamp((mouse_y - Controller.mouse_y_previous) div 4, -1, 1);
    
    switch (Camera.mouse_drag_behavior) {
        case 1:             // translate
            var sel = selection_all();
            for (var i = 0; i < ds_list_size(sel); i++) {
                var thing = sel[| i];
                map_move_thing(thing, thing.xx + dx, thing.yy + dy, thing.zz);
            }
            ds_list_destroy(sel);
            for (var i = 0; i < ds_list_size(selection); i++) {
                var sel = selection[| i];
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
    if (ds_list_size(selection) < MAX_SELECTION_COUNT) {
        if (!keyboard_check(input_selection_add) && !selection_addition) {
            selection_clear();
        }
        switch (selection_mode) {
            case SelectionModes.SINGLE: var stype = SelectionSingle; break;
            case SelectionModes.RECTANGLE: var stype = SelectionRectangle; break;
            case SelectionModes.CIRCLE: var stype = SelectionCircle; break;
        }
        
        var tz = under_cursor ? under_cursor.zz : 0;
        
        last_selection = instance_create_depth(0, 0, 0, stype);
        ds_list_add(selection, last_selection);
        script_execute(last_selection.onmousedown, last_selection, floor_cx, floor_cy, tz);
    }
}
if (Controller.mouse_left) {
    if (last_selection) {
        script_execute(last_selection.onmousedrag, last_selection, floor_cx + 1, floor_cy + 1);
    }
}
if (Controller.release_left) {
    // selections of zero area are just deleted outright
    if (last_selection) {
        if (script_execute(last_selection.area, last_selection) == 0) {
            instance_activate_object(last_selection);
            instance_destroy(last_selection);
            ds_list_pop(selection);
            last_selection = noone;
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
    var mspd = 240;
    var xspeed = 0;
    var yspeed = 0;
    
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        yspeed = yspeed - mspd * Stuff.dt;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        yspeed = yspeed + mspd * Stuff.dt;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed = xspeed - mspd * Stuff.dt;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed = xspeed + mspd * Stuff.dt;
    }
    if (false && Controller.mouse_right) {
        var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
        var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
        var dx = (MOUSE_X - camera_cx) / 16;
        var dy = (MOUSE_Y - camera_cy) / 16;
        window_mouse_set(camera_cx, camera_cy);
    }
    
    x += xspeed;
    y += yspeed;
} else {
	if (Controller.press_right) {
		Controller.press_right = false;
		// if there is no selection, select the single square under the cursor. Otherwise you might
		// want to do operations on large swaths of entities, so don't clear it or anythign like that.
		
		if (selection_empty()) {
            var tz = under_cursor ? under_cursor.zz : 0;
            last_selection = instance_create_depth(0, 0, 0, SelectionSingle);
            ds_list_add(selection, last_selection);
            script_execute(last_selection.onmousedown, last_selection, floor_cx, floor_cy, tz);
		}
		
		var menu = Camera.menu.menu_right_click;
		menu_activate_extra(menu);
		menu.x = Camera.MOUSE_X;
		menu.y = Camera.MOUSE_Y;
	}
}