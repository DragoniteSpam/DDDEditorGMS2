/// @description smf_transform_set_translation(x, y, z)
/// @param x
/// @param y
/// @param z
function smf_transform_set_translation(argument0, argument1, argument2) {
    matrix_set(matrix_world, matrix_build(argument0, argument1, argument2, 0, 0, 0, 1, 1, 1));


}
