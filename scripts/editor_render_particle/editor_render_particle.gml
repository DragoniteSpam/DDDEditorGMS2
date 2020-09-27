function editor_render_particle(mode) {
    switch (view_current) {
        case view_3d: draw_editor_particle(mode); break;
        case view_ribbon: draw_editor_menu(mode); break;
        case view_hud: draw_editor_hud(mode); break;
    }
}