/// @description smf_transform_set_rotation(xrotation, yrotation, zrotation)
/// @param xrotation
/// @param yrotation
/// @param zrotation
matrix_set(matrix_world, matrix_build(0, 0, 0, argument0, argument1, argument2, 1, 1, 1));