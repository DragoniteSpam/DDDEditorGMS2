function editor_mode_meshes() {
    Stuff.mode = Stuff.mesh_ed;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        setting_set("Config", "mode", ModeIDs.MESH);
    }

    view_set_visible(view_fullscreen, true);
    view_set_visible(view_3d, false);
    view_set_visible(view_ribbon, true);
    view_set_visible(view_hud, false);

    var camera = view_get_camera(view_fullscreen);
    camera_set_view_pos(camera, 0, 0);
    camera_set_view_size(camera, window_get_width(), window_get_height());
    view_set_wport(view_fullscreen, window_get_width());
    view_set_hport(view_fullscreen, window_get_height());


}
