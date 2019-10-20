/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var surface = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;

var map = Camera.event_map;
var map_contents = map.contents;

var mfx = (Camera.MOUSE_X - x1) / (x2 - x1);
var mfy = (Camera.MOUSE_Y - y1) / (y2 - y1);

var data_x = real(surface.root.el_input_x.value);
var data_y = real(surface.root.el_input_y.value);
var data_z = real(surface.root.el_input_z.value);

if (is_clamped(mfx, 0, 1) && is_clamped(mfy, 0, 1)) {
	ui_activate(noone);
	// please stop trying to use the (xto - x) trick, that only works if you want the vector
	// coming out of the center of the camera
	var mouse_vector = update_mouse_vector(Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_xto, Camera.event_yto, Camera.event_zto,
		Camera.event_xup, Camera.event_yup, Camera.event_zup, Camera.event_fov, (x2 - x1) / (y2 - y1), mfx, mfy);
	
	var xx = mouse_vector[vec3.xx] * MILLION;
	var yy = mouse_vector[vec3.yy] * MILLION;
	var zz = mouse_vector[vec3.zz] * MILLION;
	
	if (Controller.press_left) {
		if (c_raycast_world(Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_x + xx, Camera.event_y + yy, Camera.event_z + zz, CollisionMasks.SURFACE)) {
			var cell_x = floor(c_hit_x()) div TILE_WIDTH;
			var cell_y = floor(c_hit_y()) div TILE_HEIGHT;
			var cell_z = floor(c_hit_z()) div TILE_DEPTH;
			
			var cell_nx = c_hit_nx();
			var cell_ny = c_hit_ny();
			var cell_nz = c_hit_nz();
			
			// this will probably need to be revisited at some point but for now i'm going to leave it
			/*if (cell_nz != 0) {
				cell_z = cell_z + (cell_nz > 0) ? 1 : -1;
			} else if (cell_ny != 0) {
				cell_y = cell_y + (cell_ny > 0) ? 1 : -1;
			} else {
				cell_x = cell_x + (cell_nx > 0) ? 1 : -1;
			}*/
			
			data_x = cell_x;
			data_y = cell_y;
			data_z = cell_z;
		}
	}
}

// move the camera

if (!keyboard_check(vk_control)) {
	var mspd = (min(log10(max(abs(Camera.event_z), 1)) * 4, 320) + 1) / Stuff.dt;
	var xspeed = 0;
	var yspeed = 0;
	var zspeed = 0;
    
	if (keyboard_check(ord("W"))) {
	    xspeed = xspeed + dcos(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dsin(Camera.event_direction) * mspd * Stuff.dt;
	    zspeed = zspeed - dsin(Camera.event_pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(ord("S"))) {
	    xspeed = xspeed - dcos(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dsin(Camera.event_direction) * mspd * Stuff.dt;
	    zspeed = zspeed + dsin(Camera.event_pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(ord("A"))) {
	    xspeed = xspeed - dsin(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dcos(Camera.event_direction) * mspd * Stuff.dt;
	}
	if (keyboard_check(ord("D"))) {
	    xspeed = xspeed + dsin(Camera.event_direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dcos(Camera.event_direction) * mspd * Stuff.dt;
	}
	if (Controller.mouse_right) {
		var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
		var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
		var dx = (Camera.MOUSE_X - camera_cx) / 16;
		var dy = (Camera.MOUSE_Y - camera_cy) / 16;
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

if (keyboard_check(vk_space)) {
	if (keyboard_check_pressed(vk_left)) {
		data_x = max(--data_x, 0);
	}
	if (keyboard_check_pressed(vk_right)) {
		data_x = min(++data_x, map.xx - 1);
	}
	if (keyboard_check_pressed(vk_up)) {
		data_z = max(--data_z, 0);
	}
	if (keyboard_check_pressed(vk_down)) {
		data_z = min(++data_z, map.zz - 1);
	}
} else {
	if (keyboard_check_pressed(vk_left)) {
		data_x = max(--data_x, 0);
	}
	if (keyboard_check_pressed(vk_right)) {
		data_x = min(++data_x, map.xx - 1);
	}
	if (keyboard_check_pressed(vk_down)) {
		data_y = max(--data_y, 0);
	}
	if (keyboard_check_pressed(vk_up)) {
		data_y = min(++data_y, map.yy - 1);
	}
}

// @todo gml update chained accessors
var ed_x = surface.root.node.custom_data[| 1];
var ed_y = surface.root.node.custom_data[| 2];
var ed_z = surface.root.node.custom_data[| 3];
ed_x[| 0] = data_x;
ed_y[| 0] = data_y;
ed_z[| 0] = data_z;

ui_input_set_value(surface.root.el_input_x, string(data_x));
ui_input_set_value(surface.root.el_input_y, string(data_y));
ui_input_set_value(surface.root.el_input_z, string(data_z));