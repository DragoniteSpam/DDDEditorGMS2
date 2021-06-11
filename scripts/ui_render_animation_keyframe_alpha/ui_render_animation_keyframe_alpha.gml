/// @param UIInput
/// @param x
/// @param y
function ui_render_animation_keyframe_alpha(argument0, argument1, argument2) {

    var input = argument0;
    var xx = argument1;
    var yy = argument2;

    var animation = input.root.root.active_animation;
    var keyframe = noone;
    var timeline = input.root.root.el_timeline;
    var timeline_layer = ui_list_selection(input.root.root.el_layers);

    if (animation && (timeline_layer + 1)) {
        keyframe = animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);
    
        var kf_current = animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);
        var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    
        input.back_color = rel_current ? c_ui_select : c_white;
    
        if (!ui_is_active(input)) {
            input.value = string(animation_get_tween_alpha(animation, timeline_layer, floor(timeline.playing_moment)) / (rel_current ? rel_current.alpha : 1));
        }
    }

    // we must abuse truthiness wherever possible
    input.interactive = !!keyframe;
    input.root.tween.alpha.interactive = input.interactive;

    ui_render_input(input, xx, yy);


}
