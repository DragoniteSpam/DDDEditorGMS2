function ui_render_surface_render_mesh_collision(surface, x1, y1, x2, y2) {
    var mesh = surface.root.mesh;
    draw_clear(c_black);
    
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    
    Stuff.mesh.camera.SetProjection();
    
    // draw the grid (any other reference points)
    Stuff.graphics.DrawGridCentered();
    
    // active cube
    var axx = real(surface.root.el_x_input.value);
    var ayy = real(surface.root.el_y_input.value);
    var azz = real(surface.root.el_z_input.value);
    shader_set(shd_utility_alpha);
    shader_set_uniform_f(shader_get_uniform(shd_utility_alpha, "alpha"), 1);
    matrix_set(matrix_world, matrix_build(
        Stuff.mesh_x + (axx + mesh.xmin) * TILE_WIDTH, Stuff.mesh_y + (ayy + mesh.ymin) * TILE_HEIGHT, Stuff.mesh_z + (azz + mesh.zmin) * TILE_DEPTH,
        Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot,
        Stuff.mesh_scale * TILE_WIDTH, Stuff.mesh_scale * TILE_HEIGHT, Stuff.mesh_scale * TILE_DEPTH
    ));
    vertex_submit(Stuff.graphics.basic_cube, pr_trianglelist, -1);
    
    // draw the mesh
    shader_set_uniform_f(shader_get_uniform(shd_utility_alpha, "alpha"), surface.root.el_alpha.value);
    matrix_set(matrix_world, matrix_build(Stuff.mesh_x, Stuff.mesh_y, Stuff.mesh_z, Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot, Stuff.mesh_scale, Stuff.mesh_scale, Stuff.mesh_scale));
    switch (mesh.type) {
        case MeshTypes.RAW:
            for (var i = 0, n = array_length(mesh.submeshes); i < n; i++) {
                var tex = guid_get(mesh.submeshes[i].tex_base) ? sprite_get_texture(guid_get(mesh.submeshes[i].tex_base).picture, 0) : -1;
                vertex_submit(mesh.submeshes[i].vbuffer, pr_trianglelist, tex);
            }
            break;
    }
    shader_reset();
    
    // bounding box
    x1 = mesh.xmin * TILE_WIDTH;
    y1 = mesh.ymin * TILE_HEIGHT;
    var z1 = mesh.zmin * TILE_DEPTH;
    // the outer corner of the cube is already at (32, 32, 32) so we need to compensate for that
    var cube_bound = 32;
    x2 = mesh.xmax * TILE_WIDTH - cube_bound;
    y2 = mesh.ymax * TILE_HEIGHT - cube_bound;
    var z2 = mesh.zmax * TILE_DEPTH - cube_bound;
    
    shader_set(shd_bounding_box);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
        x1, y1, z1,
        x2, y1, z1,
        x1, y2, z1,
        x2, y2, z1,
        x1, y1, z2,
        x2, y1, z2,
        x1, y2, z2,
        x2, y2, z2,
    ]);
    
    vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
    shader_reset();
    
    matrix_set(matrix_world, matrix_build_identity());
}