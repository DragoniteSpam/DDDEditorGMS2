/// @param UIThing
function omu_animation_keyframe_tween(argument0) {

	var thing = argument0;
	var keyframe = thing.root.root.el_timeline.selected_keyframe;
	var param = thing.parameter;

	if (keyframe) {
	    var dw = 320;
	    var dh = 720;

	    var dg = dialog_create(dw, dh, "Animation Tweening", undefined, undefined, argument0);
    
	    var columns = 1;
	    var spacing = 16;
	    var ew = dw / columns - spacing * 2;
	    var eh = 24;
    
	    var b_width = 128;
	    var b_height = 32;
    
	    var yy = 64;
    
	    var el_type = create_radio_array(16, yy, "Type", ew, eh, uivc_animation_keyframe_set_tween, animation_get_keyframe_parameter_tween(keyframe, param), dg);
	    create_radio_array_options(el_type, [
	        "Ignore",
	        "None",
	        "Linear",
	        "Ease Quadratic In (Fall)",
	        "Ease Quadratic Out (Ascend)",
	        "Ease Quadratic In / Out",
	        "Ease Cubic In",
	        "Ease Cubic Out",
	        "Ease Cubic In / Out",
	        "Ease Quartic In",
	        "Ease Quartic Out",
	        "Ease Quartic In / Out",
	        "Ease Quintic In",
	        "Ease Quintic Out",
	        "Ease Quintic In / Out",
	        "Ease Sine In",
	        "Ease Sine Out",
	        "Ease Sine In / Out",
	        "Ease Exponential In",
	        "Ease Exponential Out",
	        "Ease Exponential In / Out",
	        "Ease Circular In",
	        "Ease Circular Out",
	        "Ease Circular In / Out"
	    ]);
	    el_type.param = param;
    
	    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	    ds_list_add(dg.contents,
	        el_type,
	        el_confirm
	    );
	}


}
