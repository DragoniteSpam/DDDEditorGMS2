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
var mx = mouse_x_view;
var my = mouse_y_view;
var mode = Stuff.mesh_ed;

if (point_in_rectangle(mx, my, x1, y1, x2, y2) && dialog_is_active(surface.root)) {
    var xspeed = 0;
    var yspeed = 0;
    var zspeed = 0;
    var xup = 0;
    var yup = 0;
    var zup = 1;
    var mspd = get_camera_speed(mode.z);
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        xspeed += dcos(mode.direction) * mspd;
        yspeed -= dsin(mode.direction) * mspd;
        zspeed -= dsin(mode.pitch) * mspd;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        xspeed -= dcos(mode.direction) * mspd;
        yspeed += dsin(mode.direction) * mspd;
        zspeed += dsin(mode.pitch) * mspd;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        xspeed -= dsin(mode.direction) * mspd;
        yspeed -= dcos(mode.direction) * mspd;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        xspeed += dsin(mode.direction) * mspd;
        yspeed += dcos(mode.direction) * mspd;
    }
    
    if (CONTORL_3D_LOOK) {
        var camera_cx = x1 + (x2 - x1) / 2;
        var camera_cy = y1 + (y2 - y1) / 2;
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
    mode.xup = xup;
    mode.yup = yup;
    mode.zup = zup;
}