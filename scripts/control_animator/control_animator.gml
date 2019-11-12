/// @param EditorModeAnimation

var mode = argument0;
var map = Stuff.map.active_map;
var map_contents = map.contents;

if (!map.is_3d) {
    show_error("hey so yeah you haven't implemented the 2D controls yet, you probably should though", true);
}

// move the camera

if (!keyboard_check(vk_control)) {
    var mspd = get_camera_speed(mode.z);
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