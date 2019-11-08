switch (view_current) {
    case view_3d: draw_editor_3d(id); break;
    case view_ribbon: draw_editor_menu(id, true); break;
    case view_hud: draw_editor_hud(id); break;
    // the pop-out window that isn't really a pop-out window
    case view_3d_preview: draw_preview_3d(id); draw_preview_3d_overlay(id); break;
}