/// @param UIButton
/// @param x
/// @param y
function ui_render_animation_keyframe_other(argument0, argument1, argument2) {

    var button = argument0;
    var xx = argument1;
    var yy = argument2;

    var animation = button.root.root.active_animation;
    var timeline = button.root.root.el_timeline;
    var timeline_layer = ui_list_selection(button.root.root.el_layers);
    var keyframe = (animation && (timeline_layer + 1)) ? animation_get_keyframe(animation, timeline_layer, timeline.playing_moment) : noone;

    // we must abuse truthiness wherever possible
    button.interactive = !!keyframe;

    ui_render_button(button, xx, yy);


}
