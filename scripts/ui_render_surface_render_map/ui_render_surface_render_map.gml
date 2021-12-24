function ui_render_surface_render_map(surface, x1, y1, x2, y2) {
    var map = Stuff.event.map;
    var map_contents = map.contents;
    
    var camera = view_get_camera(view_current);
    var active_view_mat = camera_get_view_mat(camera);
    var active_proj_mat = camera_get_proj_mat(camera);
    draw_clear(Settings.config.color_world);
    
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(Settings.view.threed);        // this will make things rather odd with the wrong setting
    
    draw_set_color(c_white);
    
    if (Settings.view.threed) {
        var vw = x2 - x1;
        var vh = y2 - y1;
        camera_set_view_mat(camera, matrix_build_lookat(Stuff.event.x, Stuff.event.y, Stuff.event.z, Stuff.event.xto,
            Stuff.event.yto, Stuff.event.zto, Stuff.event.xup, Stuff.event.yup, Stuff.event.zup));
        camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-Stuff.event.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
        camera_apply(camera);
    } else {
        var cwidth = camera_get_view_width(camera);
        var cheight = camera_get_view_height(camera);
        camera_set_view_mat(camera, matrix_build_lookat(Stuff.event.x, Stuff.event.y, 16000,  Stuff.event.x, Stuff.event.y, -16000, 0, 1, 0));
        camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
        camera_apply(camera);
    }
    
    shader_set(shd_ddd);
    matrix_set(matrix_world, matrix_build_identity());
    
    // @todo tileset update
    if (map.preview) {
        vertex_submit(map.preview, pr_trianglelist, sprite_get_texture(Game.graphics.tilesets[Stuff.event.map.tileset].picture, 0));
        vertex_submit(map.wpreview, pr_linelist, -1);
    }
    
    if (Settings.view.grid) {
        transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
        shader_set(shd_wireframe);
        vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
        shader_set(shd_ddd);
    }
    
    var dest_x = surface.root.node.custom_data[1][0];
    var dest_y = surface.root.node.custom_data[2][0];
    var dest_z = surface.root.node.custom_data[3][0];
    var dest_direction = surface.root.node.custom_data[4][0];
    
    transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[dest_direction], 1, 1, 1);
    transform_add((dest_x + 0.5) * TILE_WIDTH, (dest_y + 0.5) * TILE_HEIGHT, dest_z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.basic_cage, pr_trianglelist, -1);
    
    matrix_set(matrix_world, matrix_build_identity());
    
    camera_set_view_mat(camera, active_view_mat);
    camera_set_proj_mat(camera, active_proj_mat);
    camera_apply(camera);
    gpu_set_cullmode(cull_noculling);
    shader_reset();
}