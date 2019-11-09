/// @param EditorModeTerrain

var mode = argument0;

gpu_set_cullmode(cull_noculling);
switch (view_current) {
    case view_3d: draw_editor_terrain(); break;
    case view_ribbon: draw_editor_menu(true); break;
    case view_hud: draw_editor_terrain_hud(); break;
}