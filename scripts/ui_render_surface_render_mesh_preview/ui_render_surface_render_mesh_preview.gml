/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

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

// draw the mesh
var tex = sprite_get_texture(get_active_tileset().picture, 0);
matrix_set(matrix_world, matrix_build(Stuff.mesh_x, Stuff.mesh_y, Stuff.mesh_z, Stuff.mesh_xrot, Stuff.mesh_yrot, Stuff.mesh_zrot, Stuff.mesh_scale, Stuff.mesh_scale, Stuff.mesh_scale));
switch (mesh.type) {
    case MeshTypes.SMF:
        smf_model_draw(mesh.submeshes[| mesh.preview_index].vbuffer);
        break;
    case MeshTypes.RAW:
        vertex_submit(mesh.submeshes[| mesh.preview_index].vbuffer, pr_trianglelist, tex);
        vertex_submit(mesh.submeshes[| mesh.preview_index].wbuffer, pr_linelist, tex);
        break;
}

// bounding box
var x1 = mesh.xmin * TILE_WIDTH;
var y1 = mesh.ymin * TILE_HEIGHT;
var z1 = mesh.zmin * TILE_DEPTH;
// the outer corner of the cube is already at (32, 32, 32) so we need to compensate for that
var cube_bound = 32;
var x2 = mesh.xmax * TILE_WIDTH - cube_bound;
var y2 = mesh.ymax * TILE_HEIGHT - cube_bound;
var z2 = mesh.zmax * TILE_DEPTH - cube_bound;

if (mesh.xmin != mesh.xmax || mesh.ymin != mesh.ymax || mesh.zmin != mesh.zmax) {
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
}

camera_set_view_mat(camera, active_view_mat);
camera_set_proj_mat(camera, active_proj_mat);
camera_apply(camera);
gpu_set_state(original_state);
ds_map_destroy(original_state);
transform_reset();