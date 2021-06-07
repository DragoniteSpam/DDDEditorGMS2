function editor_mode_data() {
    Stuff.mode = Stuff.data;
    
    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.DATA;
    }
    
    view_set_visible(view_fullscreen, true);
    view_set_visible(view_3d, false);
    view_set_visible(view_ribbon, true);
    view_set_visible(view_hud, false);
    
    var camera = view_get_camera(view_fullscreen);
    camera_set_view_pos(camera, 0, 0);
    camera_set_view_size(camera, room_width, camera_get_view_height(camera));
    view_set_wport(view_fullscreen, room_width);
    
    // this may need to get stuffed off into its own script later
    
    if (Stuff.data.ui) {
        instance_activate_object(Stuff.data.ui);
        instance_destroy(Stuff.data.ui);
    }
    
    Stuff.data.ui = ui_init_game_data(Stuff.data);
    
    if (array_length(Game.data) > 0) {
        ui_list_select(Stuff.data.ui.el_master, 0);
    }
    
    ui_init_game_data_activate();
}