function draw_animator_overlay() {
    var w = view_get_wport(view_current);
    var h = view_get_hport(view_current);
    var lw = 4;
    
    var camera = view_get_camera(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(w / 2, h / 2, -16000,  w / 2, h / 2, 0, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(w, h, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
    
    gpu_set_cullmode(cull_noculling);
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, w, 48, false);
    draw_set_alpha(1);
    
    draw_set_font(FDefaultBold);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    
    draw_set_color(c_black);
}