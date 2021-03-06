/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2
function ui_render_surface_render_mesh_collision(argument0, argument1, argument2, argument3, argument4) {

    var surface = argument0;
    var x1 = argument1;
    var y1 = argument2;
    var x2 = argument3;
    var y2 = argument4;

    var mesh = surface.root.mesh;

    var original_state = gpu_get_state();
    var camera = view_get_camera(view_current);
    var active_view_mat = camera_get_view_mat(camera);
    var active_proj_mat = camera_get_proj_mat(camera);
    draw_clear(c_black);

    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);

    var s = 256;
    var fov = 45;   // meh
    var camera = view_get_camera(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(0, s, s / 2, 0, 0, 0, 0, 0, 1));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -(x2 - x1) / (y2 - y1), CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);

    // draw the grid, and any other reference points
    vertex_submit(Stuff.graphics.mesh_preview_grid, pr_linelist, -1);

    // active cube
    var axx = real(surface.root.el_x_input.value);
    var ayy = real(surface.root.el_y_input.value);
    var azz = real(surface.root.el_z_input.value);
    shader_set(shd_default_alpha);
    shader_set_uniform_f(shader_get_uniform(shd_default_alpha, "alpha"), 1);
    matrix_set(matrix_world, matrix_build(
        Stuff.mesh_x + (axx + mesh.xmin) * TILE_WIDTH, Stuff.mesh_y + (ayy + mesh.ymin) * TILE_HEIGHT, Stuff.mesh_z + (azz + mesh.zmin) * TILE_DEPTH,
        Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot,
        Stuff.mesh_scale * TILE_WIDTH, Stuff.mesh_scale * TILE_HEIGHT, Stuff.mesh_scale * TILE_DEPTH
    ));
    vertex_submit(Stuff.graphics.basic_cube, pr_trianglelist, -1);

    // draw the mesh
    var tex = sprite_get_texture(get_active_tileset().picture, 0);
    shader_set_uniform_f(shader_get_uniform(shd_default_alpha, "alpha"), surface.root.el_alpha.value);
    matrix_set(matrix_world, matrix_build(Stuff.mesh_x, Stuff.mesh_y, Stuff.mesh_z, Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot, Stuff.mesh_scale, Stuff.mesh_scale, Stuff.mesh_scale));
    switch (mesh.type) {
        case MeshTypes.SMF:
            smf_model_draw(mesh.submeshes[| 0].vbuffer);
            break;
        case MeshTypes.RAW:
            vertex_submit(mesh.submeshes[| 0].vbuffer, pr_trianglelist, tex);
            vertex_submit(mesh.submeshes[| 0].wbuffer, pr_linelist, tex);
            break;
    }
    shader_reset();

    // bounding box
    var x1 = mesh.xmin * TILE_WIDTH;
    var y1 = mesh.ymin * TILE_HEIGHT;
    var z1 = mesh.zmin * TILE_DEPTH;
    // the outer corner of the cube is already at (32, 32, 32) so we need to compensate for that
    var cube_bound = 32;
    var x2 = mesh.xmax * TILE_WIDTH - cube_bound;
    var y2 = mesh.ymax * TILE_HEIGHT - cube_bound;
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

    camera_set_view_mat(camera, active_view_mat);
    camera_set_proj_mat(camera, active_proj_mat);
    camera_apply(camera);
    gpu_set_state(original_state);
    ds_map_destroy(original_state);
    transform_reset();


}
