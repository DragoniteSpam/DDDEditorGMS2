/// @description  matrix transform_set(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
/// @param x
/// @param  y
/// @param  z
/// @param  xrot
/// @param  yrot
/// @param  zrot
/// @param  xscale
/// @param  yscale
/// @param  zscale

var matrix=matrix_build(argument0, argument1, argument2,
    argument3, argument4, argument5,
    argument6, argument7, argument8);

matrix_set(matrix_world, matrix);

return matrix;
