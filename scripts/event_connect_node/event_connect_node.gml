/// @param source
/// @param destination
/// @param [index]
/// @param [force-null?]
function event_connect_node() {

    var source = argument[0];
    var destination = argument[1];
    var index = (argument_count > 2) ? argument[2] : 0;
    var force_null = (argument_count > 3) ? argument[3] : false;

    // because this would be silly
    if (source != destination && (destination && destination.valid_destination) || force_null) {
        var old_node = source.outbound[| index];
        if (old_node) {
            ds_map_delete(old_node.parents, source);
        }
    
        if (destination) {
            destination.parents[? source] = true;
        }
    
        source.outbound[| index] = destination;
    }


}
