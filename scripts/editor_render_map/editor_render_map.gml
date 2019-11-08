/// @param EditorMode

var mode = argument0;

switch (view_current) {
    case view_3d: draw_editor_3d(mode); break;
    case view_ribbon: draw_editor_menu(mode, true); break;
    case view_hud: draw_editor_hud(mode); break;
    // the pop-out window that isn't really a pop-out window
    case view_3d_preview: draw_preview_3d(mode); draw_preview_3d_overlay(mode); break;
}