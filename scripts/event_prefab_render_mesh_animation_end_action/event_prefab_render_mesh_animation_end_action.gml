function event_prefab_render_mesh_animation_end_action(event, index) {
    var raw = event.custom_data[| 2][| 0];
    switch (raw) {
        case AnimationEndActions.STOP: return "Stop";
        case AnimationEndActions.LOOP: return "Loop";
        case AnimationEndActions.REVERSE: return "Reverse";
        case AnimationEndActions.END: return "End";
    }
}