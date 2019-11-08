/// @param EditorModeMap

var mode = argument0;

var camera = view_get_camera(view_3d_preview);

var w = camera_get_view_width(camera);
var h = camera_get_view_height(camera);
var lw = 4;

camera_set_view_mat(camera, matrix_build_lookat(w / 2, h / 2, -16000,  w / 2, h / 2, 0, 0, 1, 0));
camera_set_proj_mat(camera, matrix_build_projection_ortho(w, h, CAMERA_ZNEAR, CAMERA_ZFAR));
camera_apply(camera);

draw_set_alpha(0.5);
draw_set_color(c_black);
draw_rectangle(16, 16, 400, 144, false);
draw_set_alpha(1);

gpu_set_cullmode(cull_noculling);
draw_set_color(c_white);

draw_line_width_colour(0, 0, w, 0, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(0, 0, 0, h, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(w - 1, 0, w - 1, h, lw, Stuff.setting_color, Stuff.setting_color);
draw_line_width_colour(0, h - 1, w, h - 1, lw, Stuff.setting_color, Stuff.setting_color);

draw_set_font(FDefault12Bold);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(32, 32, string("Press Escape to close"));

if (keyboard_check(vk_shift)) {
    draw_text(32, 64, string("Up/Down: translate across Z"));
    draw_text(32, 80, string("Left/Right: rotate around Z"));
} else if (keyboard_check(vk_control)) {
    draw_text(32, 64, string("Up/Down: rotate around Y"));
    draw_text(32, 80, string("Left/Right: rotate around X"));
} else if (keyboard_check(vk_alt)) {
    draw_text(32, 64, string("Up/Down: scale up/down (all axes)"));
} else {
    draw_text(32, 64, string("Up/Down: translate across Y"));
    draw_text(32, 80, string("Left/Right: translate across X"));
}

draw_text(32, 112, string("Press Backspace to reset"));
draw_text(32, 128, string("Shift, Control and Alt all do different things"));

draw_set_color(c_black);