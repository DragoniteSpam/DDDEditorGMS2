/// @param DataAnimation
/// @param keyframe
/// @param layer
/// @param moment
function animation_set_keyframe_position(argument0, argument1, argument2, argument3) {

    var animation = argument0;
    var keyframe = argument1;
    var inst_layer = animation_get_layer(animation, argument2);
    var moment = argument3;

    inst_layer.keyframes[| keyframe.moment] = noone;
    keyframe.moment = moment;
    inst_layer.keyframes[| moment] = keyframe;

    return keyframe;


}
