/// @param EditorModeAnimation

var mode = argument0;

draw_clear(c_black);
var map = Stuff.map.active_map;
var map_contents = map.contents;

gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(true);

// todo GMS2 requires smooth shading to be handled by the shader(s) now,
// so to make porting this to GMS2 as pain-free as possible I'd like to
// do it that way here at some point in the future too

draw_set_color(c_white);
var camera = view_get_camera(view_current);
var view_mat = camera_get_view_mat(camera);
var proj_mat = camera_get_proj_mat(camera);

if (map.is_3d) {
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
} else {
    var cwidth = camera_get_view_width(camera);
    var cheight = camera_get_view_height(camera);
    camera_set_view_mat(camera, matrix_build_lookat(mode.x + cwidth / 2, mode.y + cheight / 2, -16000,  mode.x + cwidth / 2, mode.y + cheight / 2, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
}

// anything in the world

shader_set(shd_default);
var animation = mode.ui.active_animation;

gpu_set_cullmode(cull_noculling);
shader_reset();

if (animation) {
    var moment = mode.ui.el_timeline.playing_moment;
    for (var i = 0; i < ds_list_size(animation.layers); i++) {
        var timeline_layer = animation.layers[| i];
        var kx = animation_get_tween_translate_x(animation, i, moment);
        var ky = animation_get_tween_translate_y(animation, i, moment);
        var kz = animation_get_tween_translate_z(animation, i, moment);
        var krx = animation_get_tween_rotate_x(animation, i, moment);
        var kry = animation_get_tween_rotate_y(animation, i, moment);
        var krz = animation_get_tween_rotate_z(animation, i, moment);
        var ksx = animation_get_tween_scale_x(animation, i, moment);
        var ksy = animation_get_tween_scale_y(animation, i, moment);
        var ksz = animation_get_tween_scale_z(animation, i, moment);
        var kcolor = animation_get_tween_color(animation, i, moment);
        var kalpha = animation_get_tween_alpha(animation, i, moment);
        transform_set(kx, ky, kz, krx, kry, krz, ksx, ksy, ksz);
        vertex_submit(Stuff.graphics.grid_sphere, pr_linelist, -1);
    }
}

// "set" overwrites the previous transform anyway
transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
vertex_submit(Stuff.graphics.grid_centered, pr_linelist, -1);

transform_reset();