draw_clear(c_black);

draw_set_color(c_white);
gpu_set_zwriteenable(true);
gpu_set_cullmode(view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(true);

var camera = view_get_camera(view_current);
var vw = view_get_wport(view_current);
var vh = view_get_hport(view_current);
camera_set_view_mat(camera, matrix_build_lookat(x, y, z, xto, yto, zto, xup, yup, zup));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
camera_apply(camera);

script_execute(Stuff.terrain.render, Stuff.terrain);