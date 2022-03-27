function ui_render_surface_render_map(surface, x1, y1, x2, y2) {
    var map = Stuff.event.map;
    var map_contents = map.contents;
    
    draw_clear(Settings.config.color_world);
    
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_ztestenable(Settings.view.threed);        // this will make things rather odd with the wrong setting
    
    draw_set_color(c_white);
    
    if (Settings.view.threed) {
        self.camera.SetProjection();
    } else {
        self.camera.SetProjectionOrtho();
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
    
    gpu_set_cullmode(cull_noculling);
    shader_reset();
}