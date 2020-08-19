/// @description smf_matrix_orthogonalize(4x4matrix)
/// @param 4x4matrix
function smf_matrix_orthogonalize(argument0) {
    /*
    Script made by TheSnidr

    www.thesnidr.com
    */
    gml_pragma("forceinline");
    var M = argument0, vTo, vSi, vUp;
    vTo = smf_vector_normalize([M[0], M[1], M[2]]);
    M[@ 0] = vTo[0];
    M[@ 1] = vTo[1];
    M[@ 2] = vTo[2];
    M[@ 3] = 0;

    vUp = smf_vector_normalize(smf_vector_orthogonalize([M[0], M[1], M[2]], [M[8], M[9], M[10]]));
    M[@ 8] = vUp[0];
    M[@ 9] = vUp[1];
    M[@ 10] = vUp[2];
    M[@ 11] = 0;

    vSi = smf_vector_normalize(smf_vector_cross_product([M[8], M[9], M[10]], [M[0], M[1], M[2]]));
    M[@ 4] = vSi[0];
    M[@ 5] = vSi[1];
    M[@ 6] = vSi[2];
    M[@ 7] = 0;
    M[@ 15] = 1;

    return M;


}
