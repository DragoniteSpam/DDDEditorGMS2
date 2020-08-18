/// @param EditorModeMap
function editor_update_animation(argument0) {

	var mode = argument0;

	if (!Stuff.mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
	    control_animator(mode);
	}


}
