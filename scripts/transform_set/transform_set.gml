/// @param x
/// @param y
/// @param z
/// @param xrot
/// @param yrot
/// @param zrot
/// @param xscale
/// @param yscale
/// @param zscale
function transform_set(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8) {

	var matrix = matrix_build(
	    argument0, argument1, argument2,
	    argument3, argument4, argument5,
	    argument6, argument7, argument8
	);

	matrix_set(matrix_world, matrix);

	return matrix;


}
