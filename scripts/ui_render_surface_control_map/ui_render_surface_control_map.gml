/// @param x1
/// @param y1
/// @param x2
/// @param y2

var x1 = argument0;
var y1 = argument1;
var x2 = argument2;
var y2 = argument3;

var map = Camera.event_map;
var map_contents = map.contents;

var mfx = (Camera.MOUSE_X - x1) / (x2 - x1);
var mfy = (Camera.MOUSE_Y - y1) / (y2 - y1);

if (is_clamped(mfx, 0, 1) && is_clamped(mfy, 0, 1)) {
	var camera = view_get_camera(view_current);
	
	mouse_vector = update_mouse_vector(Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_xto, Camera.event_yto, Camera.event_zto,
		Camera.event_xup, Camera.event_yup, Camera.event_zup, Camera.event_fov, CW / CH, mfx, mfy);
	
	var xx = mouse_vector[vec3.xx] * MILLION;
	var yy = mouse_vector[vec3.yy] * MILLION;
	var zz = mouse_vector[vec3.zz] * MILLION;
	
	if (Controller.press_left) {
		if (c_raycast_object(map.cpreview, Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_x + xx, Camera.event_y + yy, Camera.event_z + zz, 1)) {
			show_message([c_hit_x(), c_hit_y(), c_hit_z()]);
		} else {
			show_message("nothing hit");
		}
		/*
		var f = abs(Camera.event_z / zz);
		floor_x = Camera.event_x + xx * f;
		floor_y = Camera.event_y + yy * f;
    
		floor_cx = clamp(floor_x div TILE_WIDTH, 0, Stuff.active_map.contents.xx);
		floor_cy = clamp(floor_y div TILE_HEIGHT, 0, Stuff.active_map.contents.yy);
		if (ds_list_size(selection) < MAX_SELECTION_COUNT) {
			if (!keyboard_check(input_selection_add) && !selection_addition) {
			    selection_clear();
			    keyboard_string = "";
			}
		    
			// replace this with something that isnt a selection in a bit
			var stype = SelectionSingle;
			
			var tz = under_cursor ? under_cursor.zz : 0;
        
			last_selection = instance_create_depth(0, 0, 0, stype);
			ds_list_add(selection, last_selection);
			script_execute(last_selection.onmousedown, last_selection, floor_cx, floor_cy, tz);
		}
		*/
	}
}

// move the camera

if (!keyboard_check(vk_control)) {
	var mspd = (min(log10(max(abs(Camera.event_z), 1)) * 4, 320) + 1) / Stuff.dt;
	var xspeed = 0;
	var yspeed = 0;
	var zspeed = 0;
    
	if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	    xspeed = xspeed + dcos(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dsin(Camera.event_direction) * mspd * Stuff.dt;
	    zspeed = zspeed - dsin(Camera.event_pitch) * mspd * Stuff.dt;
	    keyboard_string = "";
	}
	if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	    xspeed = xspeed - dcos(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dsin(Camera.event_direction) * mspd * Stuff.dt;
	    zspeed = zspeed + dsin(Camera.event_pitch) * mspd * Stuff.dt;
	    keyboard_string = "";
	}
	if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	    xspeed = xspeed - dsin(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dcos(Camera.event_direction) * mspd * Stuff.dt;
	    keyboard_string = "";
	}
	if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
	    xspeed = xspeed + dsin(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dcos(Camera.event_direction) * mspd * Stuff.dt;
	    keyboard_string = "";
	}
	if (Controller.mouse_right) {
		var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
		var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
		var dx = (MOUSE_X - camera_cx) / 16;
		var dy = (MOUSE_Y - camera_cy) / 16;
		Camera.event_direction = (360 + Camera.event_direction - dx) % 360;
		Camera.event_pitch = clamp(Camera.event_pitch + dy, -89, 89);
		window_mouse_set(camera_cx, camera_cy);
		Camera.event_xto = Camera.event_x + dcos(Camera.event_direction);
		Camera.event_yto = Camera.event_y - dsin(Camera.event_direction);
		Camera.event_zto = Camera.event_z - dsin(Camera.event_pitch);
	}
    
	Camera.event_x += xspeed;
	Camera.event_y += yspeed;
	Camera.event_z += zspeed;
	Camera.event_xto += xspeed;
	Camera.event_yto += yspeed;
	Camera.event_zto += zspeed;
	Camera.event_xup = 0;
	Camera.event_yup = 0;
	Camera.event_zup = 1;
}