/// @param EditorModeAnimation
function draw_animator(argument0) {

	var mode = argument0;

	draw_clear(c_black);
	var map = Stuff.map.active_map;
	var map_contents = map.contents;

	gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	draw_set_color(c_white);

	var camera = view_get_camera(view_current);
	var vw = view_get_wport(view_current);
	var vh = view_get_hport(view_current);
	camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
	camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
	camera_apply(camera);

	shader_set(shd_ddd);
	shader_reset();
	var animation = mode.ui.active_animation;

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
	vertex_submit(Stuff.graphics.axes_centered, pr_linelist, -1);

	transform_reset();
	shader_reset();


}
