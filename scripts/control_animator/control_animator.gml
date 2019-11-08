var map = Stuff.map.active_map;
var map_contents = map.contents;

if (!map.is_3d) {
    show_error("hey so yeah you haven't implemented the 2D controls yet, you probably should though", true);
}

// move the camera

if (!keyboard_check(vk_control)) {
    var mspd = (min(log10(max(abs(anim_z), 1)) * 4, 320) + 1) / Stuff.dt;
    var xspeed = 0;
    var yspeed = 0;
    var zspeed = 0;
    
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        xspeed = xspeed + dcos(anim_direction) * mspd * Stuff.dt;
        yspeed = yspeed - dsin(anim_direction) * mspd * Stuff.dt;
        zspeed = zspeed - dsin(anim_pitch) * mspd * Stuff.dt;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        xspeed = xspeed - dcos(anim_direction) * mspd * Stuff.dt;
        yspeed = yspeed + dsin(anim_direction) * mspd * Stuff.dt;
        zspeed = zspeed + dsin(anim_pitch) * mspd * Stuff.dt;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed = xspeed - dsin(anim_direction) * mspd * Stuff.dt;
        yspeed = yspeed - dcos(anim_direction) * mspd * Stuff.dt;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed = xspeed + dsin(anim_direction) * mspd * Stuff.dt;
        yspeed = yspeed + dcos(anim_direction) * mspd * Stuff.dt;
    }
    if (CONTORL_3D_LOOK) {
        var camera_cx = view_get_xport(view_current) + view_get_wport(view_current) / 2;
        var camera_cy = view_get_yport(view_current) + view_get_hport(view_current) / 2;
        var dx = (Stuff.MOUSE_X - camera_cx) / 16;
        var dy = (Stuff.MOUSE_Y - camera_cy) / 16;
        anim_direction = (360 + anim_direction - dx) % 360;
        anim_pitch = clamp(anim_pitch + dy, -89, 89);
        window_mouse_set(camera_cx, camera_cy);
        anim_xto = anim_x + dcos(anim_direction);
        anim_yto = anim_y - dsin(anim_direction);
        anim_zto = anim_z - dsin(anim_pitch);
    }
    
    anim_x += xspeed;
    anim_y += yspeed;
    anim_z += zspeed;
    anim_xto += xspeed;
    anim_yto += yspeed;
    anim_zto += zspeed;
    anim_xup = 0;
    anim_yup = 0;
    anim_zup = 1;
}