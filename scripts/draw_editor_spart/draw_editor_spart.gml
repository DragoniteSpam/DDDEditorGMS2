function draw_editor_spart() {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    draw_clear(c_black);
    
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    // this used to be turned off for 2D maps and there was a comment saying weird things
    // would happen, but it was causing layering issues and i havent seen anything bad
    // happen from turning it off yet
    gpu_set_ztestenable(true);
    
    draw_set_color(c_white);
    
    self.camera.SetProjection();
    
    if (Settings.view.grid) {
        shader_set(shd_wireframe);
        transform_set(0, 0, Stuff.map.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
        shader_set(shd_basic_colors);
        matrix_set(matrix_world, matrix_build_identity());
        vertex_submit(Stuff.graphics.axes, pr_trianglelist, -1);
        shader_reset();
    }
    
    // spart draw code goes here
}