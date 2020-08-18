/// @param EditorModeTerrain
function editor_update_terrain(argument0) {

	var mode = argument0;

	if (mouse_within_view(view_3d) && !dialog_exists()) {
	    if (mode.orthographic) {
	        control_terrain_3d_ortho(mode);
	    } else {
	        control_terrain_3d(mode);
	    }
	}

	var camera = view_get_camera(view_3d);
	var vw = view_get_wport(view_3d);
	var vh = view_get_hport(view_3d);

	if (mode.orthographic) {
	    var view = matrix_build_lookat(mode.x, mode.y, CAMERA_ZFAR - 256, mode.x, mode.y, 0, 0, 1, 0);
	    var proj = matrix_build_projection_ortho(-vw * mode.orthographic_scale, vh * mode.orthographic_scale, CAMERA_ZNEAR, CAMERA_ZFAR);
	} else {
	    var view = matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup);
	    var proj = matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR);
	}

	transform_set(0, 0, 0, 0, 0, 0, mode.view_scale, mode.view_scale, mode.view_scale);

	gpu_set_ztestenable(true);
	gpu_set_zwriteenable(true);

	// base terrain layer

	if (!surface_exists(mode.depth_surface_base)) {
	    mode.depth_surface_base = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
	}

	surface_set_target(mode.depth_surface_base);

	camera_set_view_mat(camera, view);
	camera_set_proj_mat(camera, proj);
	camera_apply(camera);

	draw_clear_alpha(c_black, 0);
	graphics_set_lighting_terrain(shd_terrain);
	if (mode.cursor_position == undefined) {
	    shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouse"), -MILLION, -MILLION);
	} else {
	    shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouse"), mode.cursor_position[vec2.xx], mode.cursor_position[vec2.yy]);
	}
	shader_set_uniform_f(shader_get_uniform(shd_terrain, "mouseRadius"), mode.radius);
	vertex_submit(mode.terrain_buffer, pr_trianglelist, sprite_get_texture(mode.texture, 0));
	vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
	surface_reset_target();

	// top terrain layer
	/*
	if (!surface_exists(mode.depth_surface_top)) {
	    mode.depth_surface_top = surface_create(camera_get_view_width(camera), camera_get_view_height(camera));
	}

	surface_set_target(mode.depth_surface_top);

	camera_set_view_mat(camera, view);
	camera_set_proj_mat(camera, proj);
	camera_apply(camera);

	draw_clear_alpha(c_black, 0);
	vertex_submit(mode.terrain_buffer, pr_trianglelist, sprite_get_texture(mode.texture, 0));
	vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
	*/
	//surface_reset_target();

	shader_reset();
	transform_reset();


}
