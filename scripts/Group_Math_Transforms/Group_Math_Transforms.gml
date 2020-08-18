function transform_add(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale) {
	var matrix_current = matrix_get(matrix_world);
	var matrix_addition = matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
	var matrix_new = matrix_multiply(matrix_current, matrix_addition);
	matrix_set(matrix_world, matrix_new);
	return matrix_new;
}

function transform_reset() {
	matrix_set(matrix_world, matrix_build_identity());
}

function transform_set(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale) {
	var matrix = matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
	matrix_set(matrix_world, matrix);
	return matrix;
}