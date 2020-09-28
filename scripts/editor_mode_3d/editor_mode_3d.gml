function editor_mode_3d() {
    Stuff.mode = Stuff.map;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        setting_set("Config", "mode", ModeIDs.MAP);
    }

    view_set_visible(view_fullscreen, false);
    view_set_visible(view_3d, true);
    view_set_visible(view_ribbon, true);
    view_set_visible(view_hud, true);

    var camera = view_get_camera(view_hud);
    camera_set_view_size(camera, view_hud_width_3d, camera_get_view_height(camera));
    view_set_xport(view_hud, room_width - view_hud_width_3d);
    view_set_wport(view_hud, view_hud_width_3d);

    // hard-coding this will SEVERELY screw up the whole deal with allowing the window to be
    // resized, but i'll deal with that when i have to
    var camera = view_get_camera(view_3d);
    camera_set_view_pos(camera, 0, 0);
    camera_set_view_size(camera, CW, CH);
    view_set_xport(view_3d, 0);
    view_set_yport(view_3d, 0);
    view_set_wport(view_3d, CW);
    view_set_hport(view_3d, CH);


}
