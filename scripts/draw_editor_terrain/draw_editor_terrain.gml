/// @param EditorModeTerrain

var mode = argument0;

draw_clear(c_black);

draw_set_color(c_white);
gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(true);

var camera = view_get_camera(view_current);
var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);

if (mode.orthographic) {
    camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, CAMERA_ZFAR - 256, mode.x, mode.y, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(-vw * mode.orthographic_scale, vh * mode.orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR));
} else {
    camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
}

camera_apply(camera);

if (mouse_within_view(view_3d) && !dialog_exists()) {
    if (mode.orthographic) {
        control_terrain_3d_ortho(terrain);
    } else {
        control_terrain_3d(terrain);
    }
}

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);

if (mode.view_water) {
    graphics_draw_water();
}

shader_set(shd_basic);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightEnabled"), true);
shader_set_uniform_i(shader_get_uniform(shd_basic, "lightCount"), 1);
shader_set_uniform_f_array(shader_get_uniform(shd_basic, "lightData"), [
	1, 1, -1, 0,
		0, 0, 0, 0,
		1, 1, 1, 0,
]);

transform_set(0, 0, 0, 0, 0, 0, mode.view_scale, mode.view_scale, mode.view_scale);
vertex_submit(mode.terrain_buffer, pr_trianglelist, sprite_get_texture(mode.texture, 0));

shader_reset();
transform_reset();
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);