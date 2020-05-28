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

var z2d = CAMERA_ZFAR - 256;

if (mode.orthographic) {
    var view = matrix_build_lookat(mode.x, mode.y, z2d, mode.x, mode.y, 0, 0, 1, 0);
    var proj = matrix_build_projection_ortho(-vw * mode.orthographic_scale, vh * mode.orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
} else {
    var view = matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup);
    var proj = matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
}

camera_set_view_mat(camera, view);
camera_set_proj_mat(camera, proj);
camera_apply(camera);

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
transform_set(mode.x, mode.y, mode.orthographic ? z2d : mode.z, 0, 0, 0, 1, 1, 1);
vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(Stuff.graphics.default_skybox, 0));
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
transform_reset();

if (mode.view_water) {
    graphics_set_lighting_terrain(shd_water);
    graphics_draw_water(false);
}

// This is officially the worst solution to z fighting ever, but to effectively reset the depth buffer
// the terrain layer(s) go on their own surface(s).
if (!surface_exists(mode.depth_surface_base) || surface_get_width(mode.depth_surface_base) != camera_get_view_width(camera) || surface_get_height(mode.depth_surface_base) != camera_get_view_height(camera)) {
    surface_free(mode.depth_surface_base);
    surface_free(mode.depth_surface_top);
    mode.depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
    mode.depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
}