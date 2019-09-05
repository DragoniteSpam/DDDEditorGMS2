draw_clear(c_black);

control_3d_preview();

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_cullmode(view_backface ? cull_noculling : cull_counterclockwise);
draw_set_color(c_white);

var s = 128;

var camera = view_get_camera(view_current);
var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);
camera_set_view_mat(camera, matrix_build_lookat(0, s, s / 2, 0, 0, 0, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -vw / vh, 1, s * s));
camera_apply(camera);

// draw the grid, and any other reference points
vertex_submit(mesh_preview_grid, pr_linelist, -1);

// draw the mesh
var tex = sprite_get_texture(get_active_tileset().master, 0);
matrix_set(matrix_world, matrix_build(mesh_x, mesh_y, mesh_z, mesh_xrot, mesh_yrot, mesh_zrot, mesh_scale, mesh_scale, mesh_scale));
vertex_submit(mesh_preview.vbuffer, pr_trianglelist, tex);

// draw the wireframe
vertex_submit(mesh_preview.wbuffer, pr_linelist, tex);

// clean up
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));