/// @param EventNode
/// @param index
function event_prefab_render_self_switch_name(argument0, argument1) {

    var event = argument0;
    var index = argument1;

    // @gml update
    var custom_data = event.custom_data[| 1];
    var raw = custom_data[| 0];

    return chr(ord("A") + raw);


}
