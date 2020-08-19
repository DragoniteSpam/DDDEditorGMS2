/// @description smf_matrix_invert_orientation(matrix)
/// @param 4x4matrix
function smf_matrix_invert_orientation(argument0) {
    //Returns the inverted 4x4 matrix if it is invertible, or returns a negative value if it is not
    //        http://stackoverflow.com/questions/1148309/inverting-a-4x4-matrix
    //This is a modified version of the script that only inverts the orientation part and sets translation to 0.
    /*
    Script made by TheSnidr

    www.thesnidr.com
    */
    gml_pragma("forceinline");
    var m, inv, det, i;
    m = argument0;
    inv[15] = 1;
    inv[0] =  m[5] * m[10] - m[9] * m[6];
    inv[1] = -m[1] * m[10] + m[9] * m[2];
    inv[2] =  m[1] * m[6]  - m[5] * m[2];
    inv[4] = -m[4] * m[10] + m[8] * m[6];
    inv[5] =  m[0] * m[10] - m[8] * m[2];
    inv[6] = -m[0] * m[6]  + m[4] * m[2];
    inv[8] =  m[4] * m[9]  - m[8] * m[5];
    inv[9] = -m[0] * m[9]  + m[8] * m[1];
    inv[10] = m[0] * m[5]  - m[4] * m[1];
    det = m[0] * inv[0] + m[1] * inv[4] + m[2] * inv[8];
    if (det != 0){
        det = 1.0 / det;
        for (i = 0; i < 11; i++)
            inv[i] *= det;}
    return inv;


}
