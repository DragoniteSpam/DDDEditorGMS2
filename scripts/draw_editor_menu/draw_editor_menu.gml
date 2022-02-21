function draw_editor_menu(camera_controls = false) {
    // if you're using this in debug mode the overlay is going to be
    // shown and that's going to block out the first part of the menu
    var yy = DEBUG ? 24 : 0;
    
    var camera = view_get_camera(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(room_width / 2, room_height / 2, -16000,  room_width / 2, room_height / 2, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(room_width, room_height, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
    
    if (camera_controls) draw_camera_controls_overlay();
    
    gpu_set_cullmode(cull_noculling);
    
    if (is_struct(Stuff.menu)) {
        Stuff.menu.Render(0, yy);
    } else {
        Stuff.menu.render(Stuff.menu, 0, yy);
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
    
    if (DEBUG) {
        draw_set_halign(fa_left);
        draw_rectangle_colour(0, 0, room_width, yy, false, c_white, c_white, c_white, c_white);
        var index = 0;
        draw_text_colour(128 * index++ + 16, yy / 2, "FPS: " + string(fps), c_black, c_black, c_black, c_black, 1);
        draw_text_colour(128 * index++ + 16, yy / 2, "CPU FPS: " + string(floor(fps_real_current)), c_black, c_black, c_black, c_black, 1);
        draw_text_colour(
            128 * index++ + 16, yy / 2,
            "Version: " + GM_version + ";   " +
            "Build date: " + date_datetime_string(GM_build_date) + ";   " +
            "GameMaker runtime: " + GM_runtime_version,
            c_black, c_black, c_black, c_black, 1
        );
    }
}