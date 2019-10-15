/// @description smf_matrix_create(x, y, z, to[3], up[3])
/// @param x
/// @param y
/// @param z
/// @param to[3]
/// @param up[3]
//Creates a 4x4 matrix with the to-direction as master
/*
Script made by TheSnidr

www.thesnidr.com
*/
gml_pragma("forceinline");
var vTo, vUp, vSi;
vTo = smf_vector_normalize(argument3);
vUp = smf_vector_normalize(smf_vector_orthogonalize(vTo, argument4));
vSi = smf_vector_normalize(smf_vector_cross_product(vUp, vTo));
return [vTo[0], vTo[1], vTo[2], 0,
		vSi[0], vSi[1], vSi[2], 0,
		vUp[0], vUp[1], vUp[2], 0,
		argument0, argument1, argument2, 1];