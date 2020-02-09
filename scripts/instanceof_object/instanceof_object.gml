/// @param object-checking
/// @param object-ancestor

var check = argument0;
var object = argument1;

if (!check) {
    return false;
}

if (check == object) {
    return true;
}

return object_is_ancestor(check, object);