/// @param EditorModeTerrain
function control_terrain_3d_ortho(terrain) {
    if (Stuff.menu.active_element) {
        return false;
    }
    
    var vw = view_get_wport(view_3d);
    var vh = view_get_hport(view_3d);
    
    terrain.cursor_position = new vec2(
        (Stuff.terrain.x + (mouse_x_view - vw / 2) * terrain.orthographic_scale) / terrain.view_scale,
        (Stuff.terrain.y + (mouse_y_view - vh / 2) * terrain.orthographic_scale) / terrain.view_scale
    );
    
    if (Controller.mouse_left) {
        switch (terrain.mode) {
            case TerrainModes.Z: terrain_mode_z(terrain, terrain.cursor_position, 1); break;
            case TerrainModes.TEXTURE: terrain_mode_texture(terrain, terrain.cursor_position); break;
            case TerrainModes.COLOR: terrain_mode_color(terrain, terrain.cursor_position); break;
        }
    }
    if (Controller.mouse_right) {
        switch (terrain.mode) {
            case TerrainModes.Z: terrain_mode_z(terrain, terrain.cursor_position, -1); break;
            case TerrainModes.TEXTURE: terrain_mode_texture(terrain, terrain.cursor_position); break;
            case TerrainModes.COLOR: terrain_mode_color(terrain, terrain.cursor_position, 0xffffffff); break;
        }
    }
    
    if (keyboard_check_pressed(vk_space)) {
    
    }
    if (keyboard_check_pressed(vk_delete)) {
    
    }
    
    // move the camera
    if (!keyboard_check(vk_control)) {
        var mspd = get_camera_speed(terrain.z);
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
        if (mouse_wheel_up()) {
            terrain.orthographic_scale = max(0.5, terrain.orthographic_scale * 0.95);
        } else if (mouse_wheel_down()) {
            terrain.orthographic_scale = min(10, terrain.orthographic_scale * 1.05);
        }
        
        Stuff.terrain.x += xspeed;
        Stuff.terrain.y += yspeed;
        Stuff.terrain.xto += xspeed;
        Stuff.terrain.yto += yspeed;
    } else {
        if (Controller.press_right) {

        }
    }
}