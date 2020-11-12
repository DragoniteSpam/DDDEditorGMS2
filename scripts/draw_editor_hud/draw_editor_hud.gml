function draw_editor_hud() {
    gpu_set_cullmode(cull_noculling);
    ui.render(ui);
}