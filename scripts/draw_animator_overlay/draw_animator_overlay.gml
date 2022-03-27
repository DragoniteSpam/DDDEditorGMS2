function draw_animator_overlay() {
    var w = window_get_width();
    var h = window_get_height();
    var lw = 4;
    
    Stuff.base_camera.SetProjectionOrtho();
    
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