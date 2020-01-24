/// @param instance
/// @param object

var instance = argument0;
var object = argument1;

if (!instance) {
    return false;
}

if (instance.object_index == object) {
    return true;
}

return object_is_ancestor(instance.object_index, object);