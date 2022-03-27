/// @param EditorModeMap
function editor_update_animation(argument0) {

    var mode = argument0;

    if (!Stuff.mouse_3d_lock && !dialog_exists()) {
        control_animator(mode);
    }


}
