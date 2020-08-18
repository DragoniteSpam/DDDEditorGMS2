/// @param DataAnimKeyframe
/// @param KeyframeParameter
/// @param value
function animation_set_keyframe_parameter_tween(argument0, argument1, argument2) {

	var keyframe = argument0;
	var param = argument1;
	var value = argument2;

	switch (param) {
	    case KeyframeParameters.TRANS_X: keyframe.tween_xx = value; break;
	    case KeyframeParameters.TRANS_Y: keyframe.tween_yy = value; break;
	    case KeyframeParameters.TRANS_Z: keyframe.tween_zz = value; break;
	    case KeyframeParameters.ROT_X: keyframe.tween_xrot = value; break;
	    case KeyframeParameters.ROT_Y: keyframe.tween_yrot = value; break;
	    case KeyframeParameters.ROT_Z: keyframe.tween_zrot = value; break;
	    case KeyframeParameters.SCALE_X: keyframe.tween_xscale = value; break;
	    case KeyframeParameters.SCALE_Y: keyframe.tween_yscale = value; break;
	    case KeyframeParameters.SCALE_Z: keyframe.tween_zscale = value; break;
	    case KeyframeParameters.COLOR: keyframe.tween_color = value; break;
	    case KeyframeParameters.ALPHA: keyframe.tween_alpha = value; break;
	}


}
