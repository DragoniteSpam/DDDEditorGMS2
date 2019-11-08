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

var map = Camera.event_map;
var map_contents = map.contents;

var camera = view_get_camera(view_current);
var active_view_mat = camera_get_view_mat(camera);
var active_proj_mat = camera_get_proj_mat(camera);
draw_clear(c_black);

gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(map.is_3d);        // this will make things rather odd with the wrong setting

draw_set_color(c_white);

if (map.is_3d) {
    var vw = x2 - x1;
    var vh = y2 - y1;
    camera_set_view_mat(camera, matrix_build_lookat(Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_xto,
		Camera.event_yto, Camera.event_zto, Camera.event_xup, Camera.event_yup, Camera.event_zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-Camera.event_fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
} else {
    var cwidth = camera_get_view_width(camera);
	var cheight = camera_get_view_height(camera);
    camera_set_view_mat(camera, matrix_build_lookat(Camera.event_x, Camera.event_y, 16000,  Camera.event_x, Camera.event_y, -16000, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
}

shader_set(shd_default);
transform_reset();

// @todo tileset update
if (map.preview) {
	vertex_submit(map.preview, pr_trianglelist, sprite_get_texture(Stuff.all_graphic_tilesets[| Camera.event_map.tileset].master, 0));
	vertex_submit(map.wpreview, pr_linelist, -1);
}

if (Stuff.view_grid) {
	transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Camera.grid, pr_linelist, -1);
}

var dest_x = surface.root.node.custom_data[| 1];
var dest_y = surface.root.node.custom_data[| 2];
var dest_z = surface.root.node.custom_data[| 3];
var dest_direction = surface.root.node.custom_data[| 4];
dest_x = dest_x[| 0];
dest_y = dest_y[| 0];
dest_z = dest_z[| 0];
dest_direction = dest_direction[| 0];

transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[dest_direction], 1, 1, 1);
transform_add((dest_x + 0.5) * TILE_WIDTH, (dest_y + 0.5) * TILE_HEIGHT, dest_z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
vertex_submit(Stuff.basic_cage, pr_trianglelist, -1);

transform_reset();

camera_set_view_mat(camera, active_view_mat);
camera_set_proj_mat(camera, active_proj_mat);
camera_apply(camera);
gpu_set_cullmode(cull_noculling);
shader_reset();