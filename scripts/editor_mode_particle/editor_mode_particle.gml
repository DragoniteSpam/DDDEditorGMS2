function editor_mode_particle() {
    Stuff.mode = Stuff.particle;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        setting_set("Config", "mode", ModeIDs.PARTICLE);
    }

    view_set_visible(view_fullscreen, false);
    view_set_visible(view_3d, true);
    view_set_visible(view_ribbon, true);
    view_set_visible(view_hud, true);

    var ui_x = room_width / 2;

    var camera = view_get_camera(view_hud);
    camera_set_view_size(camera, room_width - ui_x, camera_get_view_height(camera));
    view_set_xport(view_hud, ui_x);
    view_set_wport(view_hud, room_width - ui_x);

    // hard-coding this will SEVERELY screw up the whole deal with allowing the window to be
    // resized, but i'll deal with that when i have to
    var camera = view_get_camera(view_3d);
    camera_set_view_pos(camera, 0, 0);
    camera_set_view_size(camera, ui_x, CH);
    view_set_xport(view_3d, 0);
    view_set_yport(view_3d, 0);
    view_set_wport(view_3d, ui_x);
    view_set_hport(view_3d, CH);


}
