/// @param EditorModeTerrain
function control_terrain_3d(argument0) {

    var terrain = argument0;

    if (Stuff.menu.active_element) {
        return false;
    }

    var mouse_vector = update_mouse_vector(
        Stuff.terrain.x, Stuff.terrain.y, Stuff.terrain.z, Stuff.terrain.xto, Stuff.terrain.yto, Stuff.terrain.zto,
        Stuff.terrain.xup, Stuff.terrain.yup, Stuff.terrain.zup, Stuff.terrain.fov, CW / CH
    );

    var xx = mouse_vector[vec3.xx] * MILLION;
    var yy = mouse_vector[vec3.yy] * MILLION;
    var zz = mouse_vector[vec3.zz] * MILLION;

    terrain.cursor_position = undefined;

    if (zz < Stuff.terrain.z) {
        var f = abs(Stuff.terrain.z / zz);
    
        // @gml update lwo
        terrain.cursor_position = [(Stuff.terrain.x + xx * f) / terrain.view_scale, (Stuff.terrain.y + yy * f) / terrain.view_scale];
    
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
    }

    if (keyboard_check_pressed(vk_space)) {
    
    }
    if (keyboard_check_pressed(vk_delete)) {
    
    }

    // move the camera
    var mspd = get_camera_speed(terrain.z);
    var xspeed = 0;
    var yspeed = 0;
    var zspeed = 0;

    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        xspeed = xspeed + dcos(Stuff.terrain.direction) * mspd;
        yspeed = yspeed - dsin(Stuff.terrain.direction) * mspd;
        zspeed = zspeed - dsin(Stuff.terrain.pitch) * mspd;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        xspeed = xspeed - dcos(Stuff.terrain.direction) * mspd;
        yspeed = yspeed + dsin(Stuff.terrain.direction) * mspd;
        zspeed = zspeed + dsin(Stuff.terrain.pitch) * mspd;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed = xspeed - dsin(Stuff.terrain.direction) * mspd;
        yspeed = yspeed - dcos(Stuff.terrain.direction) * mspd;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed = xspeed + dsin(Stuff.terrain.direction) * mspd;
        yspeed = yspeed + dcos(Stuff.terrain.direction) * mspd;
    }
    if (CONTROL_3D_LOOK) {
        var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) / 2;
        var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) / 2;
        var dx = (mouse_x - camera_cx) / 16;
        var dy = (mouse_y - camera_cy) / 16;
        Stuff.terrain.direction = (360 + Stuff.terrain.direction - dx) % 360;
        Stuff.terrain.pitch = clamp(Stuff.terrain.pitch + dy, -89, 89);
        window_mouse_set(camera_cx, camera_cy);
        Stuff.terrain.xto = Stuff.terrain.x + dcos(Stuff.terrain.direction) * dcos(Stuff.terrain.pitch);
        Stuff.terrain.yto = Stuff.terrain.y - dsin(Stuff.terrain.direction) * dcos(Stuff.terrain.pitch);
        Stuff.terrain.zto = Stuff.terrain.z - dsin(Stuff.terrain.pitch);
    }

    Stuff.terrain.x += xspeed;
    Stuff.terrain.y += yspeed;
    Stuff.terrain.z += zspeed;
    Stuff.terrain.xto += xspeed;
    Stuff.terrain.yto += yspeed;
    Stuff.terrain.zto += zspeed;
    Stuff.terrain.xup = 0;
    Stuff.terrain.yup = 0;
    Stuff.terrain.zup = 1;


}
