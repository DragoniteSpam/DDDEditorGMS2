/// @param EditorModeTerrain

var mode = argument0;

gpu_set_cullmode(cull_noculling);
switch (view_current) {
    case view_ribbon: draw_editor_menu(mode, true); break;
    case view_fullscreen: draw_editor_fullscreen(mode); break;
}