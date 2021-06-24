function draw_animator() {
    draw_clear(c_black);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    draw_set_color(c_white);
    
    var camera = view_get_camera(view_current);
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(x, y, z, xto, yto, zto, xup, yup, zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
    
    shader_set(shd_ddd);
    shader_reset();
    var animation = ui.active_animation;
    
    if (animation) {
        var moment = ui.el_timeline.playing_moment;
        for (var i = 0; i < array_length(animation.layers); i++) {
            var timeline_layer = animation.layers[i];
            var kx = animation.GetValue(i, moment, KeyframeParameters.TRANS_X);
            var ky = animation.GetValue(i, moment, KeyframeParameters.TRANS_Y);
            var kz = animation.GetValue(i, moment, KeyframeParameters.TRANS_Z);
            var krx = animation.GetValue(i, moment, KeyframeParameters.ROT_X);
            var kry = animation.GetValue(i, moment, KeyframeParameters.ROT_Y);
            var krz = animation.GetValue(i, moment, KeyframeParameters.ROT_Z);
            var ksx = animation.GetValue(i, moment, KeyframeParameters.SCALE_X);
            var ksy = animation.GetValue(i, moment, KeyframeParameters.SCALE_Y);
            var ksz = animation.GetValue(i, moment, KeyframeParameters.SCALE_Z);
            var kcolor = animation.GetValue(i, moment, KeyframeParameters.COLOR);
            var kalpha = animation.GetValue(i, moment, KeyframeParameters.ALPHA);
            transform_set(kx, ky, kz, krx, kry, krz, ksx, ksy, ksz);
            // todo
            vertex_submit(Stuff.graphics.grid_sphere, pr_linelist, -1);
        }
    }
    
    // "set" overwrites the previous transform anyway
    transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.grid_centered, pr_linelist, -1);
    vertex_submit(Stuff.graphics.axes_centered, pr_linelist, -1);
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
}