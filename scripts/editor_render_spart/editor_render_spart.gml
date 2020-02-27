/// @param EditorMode

var mode = argument0;

switch (view_current) {
    case view_3d: draw_editor_spart(mode); break;
    case view_ribbon: draw_editor_menu(mode, true); break;
    case view_hud: draw_editor_hud(mode); break;
}