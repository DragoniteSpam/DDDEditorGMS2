/// @param original
/// @param width
/// @param height
function surface_rebuild(argument0, argument1, argument2) {

    var original = argument0;
    var width = argument1;
    var height = argument2;

    if (!surface_exists(original)) {
        return surface_create(width, height);
    }

    if (surface_get_width(original) != width || surface_get_height(original) != height) {
        surface_free(original);
        return surface_create(width, height);
    }

    return original;


}
