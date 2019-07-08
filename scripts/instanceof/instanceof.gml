/// @param instance
/// @param object

if (argument0 == noone) {
    return false;
}

if (argument0.object_index == argument1) {
    return true;
}

return object_is_ancestor(argument0.object_index, argument1);