function draw_editor_terrain_menu(mode) {
    var camera_3d = view_get_camera(view_3d);
    draw_surface(mode.depth_surface_base, camera_get_view_x(camera_3d), camera_get_view_y(camera_3d));
    //draw_surface(mode.depth_surface_top, camera_get_view_x(camera_3d), camera_get_view_y(camera_3d));
    draw_editor_menu(mode, true);
}