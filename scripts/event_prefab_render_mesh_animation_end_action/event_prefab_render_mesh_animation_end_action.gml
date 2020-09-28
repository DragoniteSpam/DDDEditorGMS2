/// @param EventNode
/// @param index
function event_prefab_render_mesh_animation_end_action(argument0, argument1) {

    var event = argument0;
    var index = argument1;

    // @gml update
    var custom_data = event.custom_data[| 2];
    var raw = custom_data[| 0];

    switch (raw) {
        case AnimationEndActions.STOP: return "Stop";
        case AnimationEndActions.LOOP: return "Loop";
        case AnimationEndActions.REVERSE: return "Reverse";
    }


}
