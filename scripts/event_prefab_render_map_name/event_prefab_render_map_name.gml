/// @param EventNode
/// @param index
function event_prefab_render_map_name(argument0, argument1) {

    var event = argument0;
    var index = argument1;

    // @gml update
    var custom_data = event.custom_data[| 0];
    var map = guid_get(custom_data[| 0]);

    return map ? map.name : "<no map>";


}
