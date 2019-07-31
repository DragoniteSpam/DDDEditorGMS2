/// @param DataAnimation
/// @param layer
/// @param moment

var animation = argument0;
var timeline_layer = argument1;
var inst_layer = animation_get_layer(animation, timeline_layer);
var moment = argument2;

var keyframe = instantiate(DataAnimKeyframe);

// you need to set the values before adding the keyframe to the timeline, because
// if the keyframe is already in the timeline it'll just get its own (zeroed) values
// when you try to get the current value at the moment
keyframe.xx = animation_get_tween_translate_x(animation, timeline_layer, moment);
keyframe.yy = animation_get_tween_translate_y(animation, timeline_layer, moment);
keyframe.zz = animation_get_tween_translate_z(animation, timeline_layer, moment);
keyframe.xrot = animation_get_tween_rotate_x(animation, timeline_layer, moment);
keyframe.yrot = animation_get_tween_rotate_y(animation, timeline_layer, moment);
keyframe.zrot = animation_get_tween_rotate_z(animation, timeline_layer, moment);
keyframe.xscale = animation_get_tween_scale_x(animation, timeline_layer, moment);
keyframe.yscale = animation_get_tween_scale_y(animation, timeline_layer, moment);
keyframe.zscale = animation_get_tween_scale_z(animation, timeline_layer, moment);
keyframe.color = animation_get_tween_color(animation, timeline_layer, moment);
keyframe.alpha = animation_get_tween_alpha(animation, timeline_layer, moment);

keyframe.moment = moment;
inst_layer.keyframes[| moment] = keyframe;

return keyframe;