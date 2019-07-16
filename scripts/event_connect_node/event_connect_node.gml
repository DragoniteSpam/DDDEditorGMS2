/// @param source
/// @param destination
/// @param [index]

var index = (argument_count > 3) ? argument[3] : 0;

// because this would be silly
if (argument[0] != argument[1]) {
    var old_node = argument[0].outbound[| index];
    if (old_node) {
        ds_map_delete(old_node.parents, argument[0]);
    }
    
    argument[1].parents[? argument[0]] = true;
    argument[0].outbound[| index] = argument[1];
}