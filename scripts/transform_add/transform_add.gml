/// @description matrix transform_add(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
/// @param x
/// @param y
/// @param z
/// @param xrot
/// @param yrot
/// @param zrot
/// @param xscale
/// @param yscale
/// @param zscale

var matrix_current=matrix_get(matrix_world);
var matrix_addition=matrix_build(argument0, argument1, argument2,
    argument3, argument4, argument5,
    argument6, argument7, argument8);
var matrix_new=matrix_multiply(matrix_current, matrix_addition);

matrix_set(matrix_world, matrix_new);

return matrix_new;
