function draw_animator() {
    draw_clear(c_black);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    draw_set_color(c_white);
    
    self.camera.SetProjection();
    
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
            // todo draw whatever is supposed to be drawn here
            Stuff.graphics.DrawWireSphere(kx, ky, kz, krx, kry, krz, ksx, ksy, ksz);
        }
    }
    
    Stuff.graphics.DrawGridCentered();
    Stuff.graphics.DrawAxesCentered();
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
    gpu_set_zwriteenable(false);
    gpu_set_ztestenable(false);
}