/// @param EditorModeTerrain

var terrain = argument0;

if (Stuff.menu.active_element) {
	return false;
}

var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);
// @todo gml update lwo
terrain.cursor_position = [
    (Camera.x + (mouse_x_view - vw / 2) * terrain.orthographic_scale) / terrain.view_scale,
    (Camera.y + (mouse_y_view - vh / 2) * terrain.orthographic_scale) / terrain.view_scale
];

if (Controller.mouse_left) {
    switch (terrain.mode) {
        case TerrainModes.Z: terrain_mode_z(terrain, terrain.cursor_position, 1); break;
        case TerrainModes.TEXTURE: terrain_mode_texture(terrain, terrain.cursor_position); break;
        case TerrainModes.COLOR: terrain_mode_color(terrain, terrain.cursor_position) break;
    }
}
if (Controller.mouse_right) {
    switch (terrain.mode) {
        case TerrainModes.Z: terrain_mode_z(terrain, terrain.cursor_position, -1); break;
        case TerrainModes.TEXTURE: terrain_mode_texture(terrain, terrain.cursor_position); break;
        case TerrainModes.COLOR: terrain_mode_color(terrain, terrain.cursor_position, 0xffffffff) break;
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
    if (mouse_wheel_up()) {
        terrain.orthographic_scale = max(0.5, terrain.orthographic_scale * 0.95);
    } else if (mouse_wheel_down()) {
        terrain.orthographic_scale = min(10, terrain.orthographic_scale * 1.05);
    }
    
	Camera.x += xspeed;
	Camera.y += yspeed;
	Camera.xto += xspeed;
	Camera.yto += yspeed;
} else {
	if (Controller.press_right) {

	}
}