function control_animator(mode) {
    var mspd = get_camera_speed(mode.z);
    var xspeed = 0;
    var yspeed = 0;
    var zspeed = 0;
    
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        xspeed = xspeed + dcos(mode.direction) * mspd;
        yspeed = yspeed - dsin(mode.direction) * mspd;
        zspeed = zspeed - dsin(mode.pitch) * mspd;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        xspeed = xspeed - dcos(mode.direction) * mspd;
        yspeed = yspeed + dsin(mode.direction) * mspd;
        zspeed = zspeed + dsin(mode.pitch) * mspd;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed = xspeed - dsin(mode.direction) * mspd;
        yspeed = yspeed - dcos(mode.direction) * mspd;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed = xspeed + dsin(mode.direction) * mspd;
        yspeed = yspeed + dcos(mode.direction) * mspd;
    }
    if (CONTROL_3D_LOOK) {
        // @todo this used to be one of the weird view things
        var camera_cx = window_get_width() div 2;
        var camera_cy = window_get_height() div 2;
        var dx = (mouse_x - camera_cx) / 16;
        var dy = (mouse_y - camera_cy) / 16;
        mode.direction = (360 + mode.direction - dx) % 360;
        mode.pitch = clamp(mode.pitch + dy, -89, 89);
        window_mouse_set(camera_cx, camera_cy);
        mode.xto = mode.x + dcos(mode.direction) * dcos(mode.pitch);
        mode.yto = mode.y - dsin(mode.direction) * dcos(mode.pitch);
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