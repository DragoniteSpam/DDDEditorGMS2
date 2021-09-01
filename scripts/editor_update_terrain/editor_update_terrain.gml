function editor_update_terrain(mode) {
    if (mouse_within_view(view_3d) && !dialog_exists()) {
        if (mode.orthographic) {
            control_terrain_3d_ortho(mode);
        } else {
            control_terrain_3d(mode);
        }
    }
}