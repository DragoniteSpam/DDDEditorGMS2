/// @param EditorMode

var mode = argument0;

gpu_set_cullmode(cull_noculling);
switch (view_current) {
    case view_fullscreen: draw_editor_animation(mode); break;
    case view_3d: draw_animator(mode); draw_animator_overlay(mode); break;
    case view_ribbon: draw_editor_menu(mode); break;
}