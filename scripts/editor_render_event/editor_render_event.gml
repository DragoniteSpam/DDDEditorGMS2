/// @param EditorModeEvent

var mode = argument0;

gpu_set_cullmode(cull_noculling);
switch (view_current) {
    case view_fullscreen: draw_editor_event(mode); break;
    case view_ribbon: draw_editor_menu(mode); break;
    case view_hud: draw_editor_event_hud(mode); break;
}