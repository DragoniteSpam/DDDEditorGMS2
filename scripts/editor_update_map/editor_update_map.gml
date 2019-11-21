/// @param EditorModeMap

var mode = argument0;

if (!Stuff.mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
    var map = mode.active_map;
    var map_contents = map.contents;
    if (map.is_3d) {
        control_map_3d(mode);
    } else {
        control_map_2d(mode);
    }
}