function draw_editor_animation() {
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    
    draw_set_font(FDefault);
    draw_set_valign(fa_middle);
    draw_clear(EMU_COLOR_BACK);
    
    if (ui) {
        if (is_struct(ui)) {
            ui.Render(0, 0);
        } else {
            ui.render(ui, 0, 0);
        }
    }
}