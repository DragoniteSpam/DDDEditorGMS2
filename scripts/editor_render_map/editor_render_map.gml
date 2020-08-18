/// @param EditorMode
function editor_render_map(argument0) {

	var mode = argument0;

	switch (view_current) {
	    case view_3d: draw_editor_3d(mode); break;
	    case view_ribbon: draw_editor_menu(mode, true); break;
	    case view_hud: draw_editor_hud(mode); break;
	}


}
