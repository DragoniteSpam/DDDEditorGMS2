function editor_render_terrain(mode) {
    gpu_set_cullmode(cull_noculling);
    switch (view_current) {
        case view_3d: draw_clear(c_black); draw_editor_terrain(mode); draw_editor_3d(Stuff.map); break;
        case view_ribbon: draw_editor_terrain_menu(mode); break;
        case view_hud: draw_editor_hud(mode); break;
    }
}