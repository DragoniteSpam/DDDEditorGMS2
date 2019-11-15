/// @param EditorModeTerrain

var mode = argument0;

if (mouse_within_view(view_current) && !dialog_exists()) {
    if (mode.orthographic) {
        control_terrain_3d_ortho(terrain);
    } else {
        control_terrain_3d(terrain);
    }
}

surface_set_target(mode.depth_surface_base);

var camera = camera_get_default();
var vw = view_get_wport(view_3d);
var vh = view_get_hport(view_3d);

if (mode.orthographic) {
    var view = matrix_build_lookat(mode.x, mode.y, CAMERA_ZFAR - 256, mode.x, mode.y, 0, 0, 1, 0);
    var proj = matrix_build_projection_ortho(-vw * mode.orthographic_scale, vh * mode.orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
} else {
    var view = matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup);
    var proj = matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
}

camera_set_view_mat(camera, view);
camera_set_proj_mat(camera, proj);
camera_apply(camera);

draw_clear_alpha(c_black, 0);
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
gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
surface_reset_target();