/// @param DataAnimKeyframe
/// @param KeyframeParameter
function animation_get_keyframe_parameter_tween(argument0, argument1) {

	var keyframe = argument0;
	var param = argument1;

	switch (param) {
	    case KeyframeParameters.TRANS_X: return keyframe.tween_xx;
	    case KeyframeParameters.TRANS_Y: return keyframe.tween_yy;
	    case KeyframeParameters.TRANS_Z: return keyframe.tween_zz;
	    case KeyframeParameters.ROT_X: return keyframe.tween_xrot;
	    case KeyframeParameters.ROT_Y: return keyframe.tween_yrot;
	    case KeyframeParameters.ROT_Z: return keyframe.tween_zrot;
	    case KeyframeParameters.SCALE_X: return keyframe.tween_xscale;
	    case KeyframeParameters.SCALE_Y: return keyframe.tween_yscale;
	    case KeyframeParameters.SCALE_Z: return keyframe.tween_zscale;
	    case KeyframeParameters.COLOR: return keyframe.tween_color;
	    case KeyframeParameters.ALPHA: return keyframe.tween_alpha;
	}


}
