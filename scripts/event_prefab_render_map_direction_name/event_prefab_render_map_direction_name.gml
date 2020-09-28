/// @param EventNode
/// @param index
function event_prefab_render_map_direction_name(argument0, argument1) {

    var event = argument0;
    var index = argument1;

    // @gml update
    var custom_data = event.custom_data[| 4];
    var raw = custom_data[| 0];

    switch (raw) {
        case 0: return "Down";
        case 1: return "Left";
        case 2: return "Right";
        case 3: return "Up";
    }


}
