function editor_render_data(mode) {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_fullscreen: draw_editor_fullscreen(mode); break;
        case view_ribbon: draw_editor_menu(mode); break;
    }
}