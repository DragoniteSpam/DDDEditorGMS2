function event_prefab_render_mesh_animation_end_action(event, index) {
    return global.animation_end_action_names[event.custom_data[| 2][| 0]];
}