function event_prefab_render_map_name(event, index) {
    var map = guid_get(event.custom_data[| 0][| 0]);
    return map ? map.name : "<no map>";
}