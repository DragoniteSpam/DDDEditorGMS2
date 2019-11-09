/// @param EditorModeTerrain

var mode = argument0;

if (Stuff.menu.active_element) {
	return false;
}

var mouse_vector = update_mouse_vector(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup, mode.fov, CW / CH);

var xx = mouse_vector[vec3.xx] * MILLION;
var yy = mouse_vector[vec3.yy] * MILLION;
var zz = mouse_vector[vec3.zz] * MILLION;

if (c_raycast_world(mode.x, mode.y, mode.z, mode.x + xx, mode.y + yy, mode.z + zz, CollisionMasks.MAIN)) {
    mode.under_cursor = c_object_get_userid(c_hit_object(0));
} else {
    mode.under_cursor = noone;
}

var floor_x = -1;
var floor_y = -1;
var floor_cx = -1;
var floor_cy = -1;

if (zz < mode.z) {
	var f = abs(mode.z / zz);
	floor_x = mode.x + xx * f;
	floor_y = mode.y + yy * f;
    
	// the bounds on this are weird - in some places the cell needs to be rounded up and in others it
	// needs to be rounded down, so the minimum allowed "cell" is (-1, -1) - be sure to max() this later
	// if it would cause issues
	floor_cx = clamp(floor_x div TILE_WIDTH, -1, Stuff.map.active_map.xx - 1);
	floor_cy = clamp(floor_y div TILE_HEIGHT, -1, Stuff.map.active_map.yy - 1);
    
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
		    script_execute(mode.last_selection.onmousedown, mode.last_selection, max(0, floor_cx), max(0, floor_cy), tz);
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
}

if (keyboard_check_pressed(vk_space)) {
	sa_fill();
}
if (keyboard_check_pressed(vk_delete)) {
	sa_delete();
}

// move the camera

if (!keyboard_check(vk_control)) {
	var mspd = (min(log10(max(abs(mode.z), 1)) * 4, 320) + 1) / Stuff.dt;
	var xspeed = 0;
	var yspeed = 0;
	var zspeed = 0;
    
	if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	    xspeed = xspeed + dcos(mode.direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dsin(mode.direction) * mspd * Stuff.dt;
	    zspeed = zspeed - dsin(mode.pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	    xspeed = xspeed - dcos(mode.direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dsin(mode.direction) * mspd * Stuff.dt;
	    zspeed = zspeed + dsin(mode.pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	    xspeed = xspeed - dsin(mode.direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dcos(mode.direction) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
	    xspeed = xspeed + dsin(mode.direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dcos(mode.direction) * mspd * Stuff.dt;
	}
	if (CONTORL_3D_LOOK) {
		var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
		var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
		var dx = (Stuff.MOUSE_X - camera_cx) / 16;
		var dy = (Stuff.MOUSE_Y - camera_cy) / 16;
		mode.direction = (360 + mode.direction - dx) % 360;
		mode.pitch = clamp(mode.pitch + dy, -89, 89);
		window_mouse_set(camera_cx, camera_cy);
		mode.xto = mode.x + dcos(mode.direction);
		mode.yto = mode.y - dsin(mode.direction);
		mode.zto = mode.z - dsin(mode.pitch);
	}
    
	mode.x += xspeed;
	mode.y += yspeed;
	mode.z += zspeed;
	mode.xto += xspeed;
	mode.yto += yspeed;
	mode.zto += zspeed;
	mode.xup = 0;
	mode.yup = 0;
	mode.zup = 1;
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