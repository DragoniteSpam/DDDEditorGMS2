/// @description smf_transform_set_billboard(x, y, z, [camXto, camYto, camZto], [camXup, camYup, camZup])
/// @function smf_transform_set_billboard
/// @param x, y, z, [camXto, camYto, camZto], [camXup, camYup, camZup]
function smf_transform_set_billboard(argument0, argument1, argument2, argument3, argument4) {
	matrix_set(matrix_world, matrix_multiply(matrix_build(0, 0, 0, 90, 0, 270, 1, 1, 1), smf_matrix_create(argument0, argument1, argument2, argument3, argument4)));


}
