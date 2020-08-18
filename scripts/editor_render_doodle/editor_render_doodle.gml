/// @param EditorMode
function editor_render_doodle(argument0) {

	var mode = argument0;

	switch (view_current) {
	    case view_ribbon: draw_editor_menu(mode); break;
	    case view_fullscreen: draw_editor_fullscreen(mode); break;
	}


}
