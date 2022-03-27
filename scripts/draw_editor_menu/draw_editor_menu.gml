function draw_editor_menu(camera_controls = false) {
    if (camera_controls) draw_camera_controls_overlay();
    
    gpu_set_cullmode(cull_noculling);
    
    if (is_struct(Stuff.menu)) {
        Stuff.menu.Render(0, 0);
    } else {
        Stuff.menu.render(Stuff.menu, 0, 0);
    }
    
    static fps_real_history = ds_list_create();
    static fps_real_current = 60;
    static fps_real_interval = 20;
    ds_list_add(fps_real_history, fps_real);
    
    if (ds_list_size(fps_real_history) == fps_real_interval) {
        fps_real_current = 0;
        for (var i = 0, n = fps_real_interval; i < n; i++) {
            fps_real_current += fps_real_history[| i];
        }
        fps_real_current /= fps_real_interval;
        ds_list_clear(fps_real_history);
    }
    
    if (DEBUG && Settings.config.show_debug_ribbon) {
        var rh = 24;
        draw_set_halign(fa_left);
        draw_rectangle_colour(0, room_height - rh, room_width, room_height, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
        var index = 0;
        draw_text_colour(128 * index++ + 16, room_height - rh / 2, "FPS: " + string(fps), EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, 1);
        draw_text_colour(128 * index++ + 16, room_height - rh / 2, "CPU FPS: " + string(floor(fps_real_current)), EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, 1);
        draw_text_colour(
            128 * index++ + 16, room_height - rh / 2,
            "Version: " + GM_version + ";   " +
            "Build date: " + date_datetime_string(GM_build_date) + ";   " +
            "GameMaker runtime: " + GM_runtime_version,
            EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, EMU_COLOR_TEXT, 1
        );
    }
}