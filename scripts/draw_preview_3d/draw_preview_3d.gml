/// @param EditorModeMap

var mode = argument0;

draw_clear(c_black);

control_3d_preview();

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
draw_set_color(c_white);

var s = 128;
var fov = 45;   // meh
var camera = view_get_camera(view_current);
var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);
camera_set_view_mat(camera, matrix_build_lookat(0, s, s / 2, 0, 0, 0, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
camera_apply(camera);

// draw the grid, and any other reference points
vertex_submit(Stuff.graphics.mesh_preview_grid, pr_linelist, -1);

// draw the mesh
var tex = sprite_get_texture(get_active_tileset().master, 0);
matrix_set(matrix_world, matrix_build(Stuff.mesh_x, Stuff.mesh_y, Stuff.mesh_z, Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot, Stuff.mesh_scale, Stuff.mesh_scale, Stuff.mesh_scale));
vertex_submit(Stuff.mesh_preview.vbuffer, pr_trianglelist, tex);

// draw the wireframe
vertex_submit(Stuff.mesh_preview.wbuffer, pr_linelist, tex);

// clean up
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));