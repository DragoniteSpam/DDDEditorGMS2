/// @param UIInputColor
/// @param x
/// @param y
function ui_render_animation_keyframe_color(argument0, argument1, argument2) {

    var input = argument0;
    var xx = argument1;
    var yy = argument2;

    var animation = input.root.root.active_animation;
    var keyframe = noone;
    var timeline = input.root.root.el_timeline;
    var timeline_layer = ui_list_selection(input.root.root.el_layers);

    if (animation && (timeline_layer + 1)) {
        keyframe = animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);
    
        if (!ui_is_active(input)) {
            ui_input_set_value(input, animation_get_tween_color(animation, timeline_layer, floor(timeline.playing_moment)));
        }
    }

    // we must abuse truthiness wherever possible
    input.interactive = !!keyframe;
    input.root.tween_color.interactive = input.interactive;

    ui_render_color_picker(input, xx, yy);


}
