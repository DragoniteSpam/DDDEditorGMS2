/// @param source
/// @param destination
/// @param [index]

var source = argument[0];
var destination = argument[1];
var index = (argument_count > 3) ? argument[3] : 0;

// because this would be silly
if (source != destination && destination.valid_destination) {
    var old_node = source.outbound[| index];
    if (old_node) {
        ds_map_delete(old_node.parents, source);
    }
    
    destination.parents[? source] = true;
    source.outbound[| index] = destination;
}