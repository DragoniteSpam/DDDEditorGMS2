function editor_update_map(mode) {
    if (!Stuff.mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
        var map = mode.active_map;
        var map_contents = map.contents;
        control_map(mode);
    }
}