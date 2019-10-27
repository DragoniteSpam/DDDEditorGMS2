/// @param EditorModeTerrain

var terrain = argument0;

if (Camera.menu.active_element) {
	return false;
}

var mouse_vector = update_mouse_vector(
    Camera.x, Camera.y, Camera.z, Camera.xto, Camera.yto, Camera.zto,
    Camera.xup, Camera.yup, Camera.zup, Camera.fov, CW / CH
);

var xx = mouse_vector[vec3.xx] * MILLION;
var yy = mouse_vector[vec3.yy] * MILLION;
var zz = mouse_vector[vec3.zz] * MILLION;

terrain.cursor_position = undefined;

if (zz < Camera.z) {
	var f = abs(Camera.z / zz);
    
    // @todo gml update lwo
    terrain.cursor_position = [
	    clamp((Camera.x + xx * f) / terrain.view_scale, -1, terrain.width - 1),
	    clamp((Camera.y + yy * f) / terrain.view_scale, -1, terrain.height - 1)
    ];
    
	if (Controller.press_left) {

	}
	if (Controller.mouse_left) {

	}
	if (Controller.release_left) {

	}
}

if (keyboard_check_pressed(vk_space)) {
	
}
if (keyboard_check_pressed(vk_delete)) {
	
}

// move the camera

if (!keyboard_check(vk_control)) {
	var mspd = (min(log10(max(abs(Camera.z), 1)) * 4, 320) + 1) / Stuff.dt;
	var xspeed = 0;
	var yspeed = 0;
	var zspeed = 0;
    
	if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
	    xspeed = xspeed + dcos(Camera.direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dsin(Camera.direction) * mspd * Stuff.dt;
	    zspeed = zspeed - dsin(Camera.pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
	    xspeed = xspeed - dcos(Camera.direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dsin(Camera.direction) * mspd * Stuff.dt;
	    zspeed = zspeed + dsin(Camera.pitch) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
	    xspeed = xspeed - dsin(Camera.direction) * mspd * Stuff.dt;
	    yspeed = yspeed - dcos(Camera.direction) * mspd * Stuff.dt;
	}
	if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
	    xspeed = xspeed + dsin(Camera.direction) * mspd * Stuff.dt;
	    yspeed = yspeed + dcos(Camera.direction) * mspd * Stuff.dt;
	}
	if (Controller.mouse_right) {
		var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
		var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
		var dx = (Camera.MOUSE_X - camera_cx) / 16;
		var dy = (Camera.MOUSE_Y - camera_cy) / 16;
		Camera.direction = (360 + Camera.direction - dx) % 360;
		Camera.pitch = clamp(Camera.pitch + dy, -89, 89);
		window_mouse_set(camera_cx, camera_cy);
		Camera.xto = Camera.x + dcos(Camera.direction);
		Camera.yto = Camera.y - dsin(Camera.direction);
		Camera.zto = Camera.z - dsin(Camera.pitch);
	}
    
	Camera.x += xspeed;
	Camera.y += yspeed;
	Camera.z += zspeed;
	Camera.xto += xspeed;
	Camera.yto += yspeed;
	Camera.zto += zspeed;
	Camera.xup = 0;
	Camera.yup = 0;
	Camera.zup = 1;
} else {
	if (Controller.press_right) {

	}
}