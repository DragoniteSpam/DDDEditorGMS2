function draw_editor_fullscreen() {
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    
    draw_set_color(c_white);
    draw_set_font(FDefault12);
    draw_set_valign(fa_middle);
    draw_clear(c_white);
    
    if (ui) ui.render(ui, 0, 0);
}