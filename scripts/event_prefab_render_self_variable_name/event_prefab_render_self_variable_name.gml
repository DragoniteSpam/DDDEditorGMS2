function event_prefab_render_self_variable_name(event, index) {
    return chr(ord("A") + event.custom_data[| 1][| 0]);
}