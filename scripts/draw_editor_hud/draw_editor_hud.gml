function draw_editor_hud() {
    gpu_set_cullmode(cull_noculling);
    draw_clear(c_white);
    
    if (ui) {
        if (is_struct(ui)) {
            ui.Render(0, 0);
        } else {
            ui.render(ui, 0, 0);
        }
    }
}