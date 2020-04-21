Stuff.mode = Stuff.doodle;

if (!EDITOR_FORCE_SINGLE_MODE) {
    setting_set("Config", "mode", ModeIDs.DOODLE);
}

view_set_visible(view_fullscreen, true);
view_set_visible(view_3d, false);
view_set_visible(view_ribbon, true);
view_set_visible(view_hud, false);

var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, 0, 0);
camera_set_view_size(camera, room_width, camera_get_view_height(camera));
view_set_wport(view_fullscreen, room_width);