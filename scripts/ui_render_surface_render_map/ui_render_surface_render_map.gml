// no arguments - this should run without any knowledge that it's being
// controlled by a UI element

var map = Stuff.active_map;
var map_contents = map.contents;

var camera = view_get_camera(view_current);
var active_view_mat = camera_get_view_mat(camera);
var active_proj_mat = camera_get_proj_mat(camera);
draw_clear(c_black);

gpu_set_zwriteenable(true);
gpu_set_cullmode(Camera.view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(map.is_3d);        // this will make things rather odd with the wrong setting

draw_set_color(c_white);

if (map.is_3d) {
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(Camera.event_x, Camera.event_y, Camera.event_z, Camera.event_xto,
		Camera.event_yto, Camera.event_zto, Camera.event_xup, Camera.event_yup, Camera.event_zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-Camera.event_fov, -vw / vh, 1, 32000));
    camera_apply(camera);
} else {
    var cwidth = camera_get_view_width(camera);
	var cheight = camera_get_view_height(camera);
    camera_set_view_mat(camera, matrix_build_lookat(Camera.event_x, Camera.event_y, 16000,  Camera.event_x, Camera.event_y, -16000, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, 1, 32000));
    camera_apply(camera);
}

shader_set(shd_default);

// @todo tileset update
vertex_submit(Camera.event_map.preview, pr_trianglelist, sprite_get_texture(Stuff.all_tilesets[| Camera.event_map.tileset].master, 0));

if (Camera.view_grid) {
	transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Camera.grid, pr_linelist, -1);
}

transform_reset();

camera_set_view_mat(camera, active_view_mat);
camera_set_proj_mat(camera, active_proj_mat);
camera_apply(camera);
gpu_set_cullmode(cull_noculling);
shader_reset();