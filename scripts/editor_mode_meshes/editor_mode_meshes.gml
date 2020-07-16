Stuff.mode = Stuff.mesh_ed;

if (!EDITOR_FORCE_SINGLE_MODE) {
    setting_set("Config", "mode", ModeIDs.MESH);
}

view_set_visible(view_fullscreen, true);
view_set_visible(view_3d, false);
view_set_visible(view_ribbon, true);
view_set_visible(view_hud, false);