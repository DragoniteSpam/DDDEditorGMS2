/// @param keyframe
function animation_get_keyframe_has_tween(argument0) {
	// just checks to see if *any* of the tweens it uses are typed - it doesn't really
	// care which ones they are

	var keyframe = argument0;

	if (keyframe.tween_xx != AnimationTweens.NONE && keyframe.tween_xx != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_yy != AnimationTweens.NONE && keyframe.tween_yy != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_zz != AnimationTweens.NONE && keyframe.tween_zz != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_xrot != AnimationTweens.NONE && keyframe.tween_xrot != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_yrot != AnimationTweens.NONE && keyframe.tween_yrot != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_zrot != AnimationTweens.NONE && keyframe.tween_zrot != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_xscale != AnimationTweens.NONE && keyframe.tween_xscale != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_yscale != AnimationTweens.NONE && keyframe.tween_yscale != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_zscale != AnimationTweens.NONE && keyframe.tween_zscale != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_color != AnimationTweens.NONE && keyframe.tween_color != AnimationTweens.IGNORE) return true;
	if (keyframe.tween_alpha != AnimationTweens.NONE && keyframe.tween_alpha != AnimationTweens.IGNORE) return true;

	return false;


}
