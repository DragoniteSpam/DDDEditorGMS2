/// @param UIThing
function uivc_animation_set_code(argument0) {

    var thing = argument0;
    var animation = thing.root.root.root.active_animation;

    if (animation) {
        animation.code = thing.value;
    }


}
