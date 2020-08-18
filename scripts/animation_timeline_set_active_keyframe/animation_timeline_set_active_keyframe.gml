/// @param timeline
/// @param keyframe
function animation_timeline_set_active_keyframe(argument0, argument1) {

	var timeline = argument0;
	var keyframe = argument1;

	timeline.selected_keyframe = keyframe;

	if (keyframe) {
	    var keyframe_panel = timeline.root.el_keyframe;
	    ui_input_set_value(keyframe_panel.translate_x, string(keyframe.xx));
	    ui_input_set_value(keyframe_panel.translate_y, string(keyframe.yy));
	    ui_input_set_value(keyframe_panel.translate_z, string(keyframe.zz));
	    ui_input_set_value(keyframe_panel.rotate_x, string(keyframe.xrot));
	    ui_input_set_value(keyframe_panel.rotate_y, string(keyframe.yrot));
	    ui_input_set_value(keyframe_panel.rotate_z, string(keyframe.zrot));
	    ui_input_set_value(keyframe_panel.scale_x, string(keyframe.xscale));
	    ui_input_set_value(keyframe_panel.scale_y, string(keyframe.yscale));
	    ui_input_set_value(keyframe_panel.scale_z, string(keyframe.zscale));
	    keyframe_panel.color.value = keyframe.color;
	    ui_input_set_value(keyframe_panel.alpha, string(keyframe.alpha));
	    // events can't be tweened, and the UI is just a button
	}


}
