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
var mode = Stuff.mesh_ed;
var mesh_list = surface.root.mesh_list;
var sw = surface_get_width(surface.surface);
var sh = surface_get_height(surface.surface);
draw_clear(c_black);
var cam = camera_get_active();
camera_set_view_mat(cam, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-mode.fov, -sh / sw, 1, 1000));
camera_apply(cam);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

transform_reset();
vertex_submit(Stuff.graphics.mesh_preview_grid, pr_linelist, -1);
vertex_submit(Stuff.graphics.axes_width, pr_linelist, -1);

transform_set(0, 0, 0, 0, 0, 0, mode.draw_scale, mode.draw_scale, mode.draw_scale);
var n = 0;
var limit = 10;
var tex = mode.use_textures ? sprite_get_texture(get_active_tileset().master, 0) : -1;
for (var index = ds_map_find_first(mesh_list.selected_entries); index != undefined; index = ds_map_find_next(mesh_list.selected_entries, index)) {
    var mesh_data = Stuff.all_meshes[| index];
    vertex_submit(mesh_data.submeshes[| 0].vbuffer, pr_trianglelist, tex);
    vertex_submit(mesh_data.submeshes[| 0].wbuffer, pr_linelist, -1);
    if (++n > limit) break;
}
transform_reset();

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);