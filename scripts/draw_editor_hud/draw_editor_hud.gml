function draw_editor_hud(mode) {
    gpu_set_cullmode(cull_noculling);
    script_execute(mode.ui.render, mode.ui);
}