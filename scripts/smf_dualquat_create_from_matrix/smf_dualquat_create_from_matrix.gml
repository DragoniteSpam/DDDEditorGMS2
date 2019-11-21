/// @description smf_dualquat_create_from_matrix(M[16])
/// @param M[16]
//Creates a dual quaternion from a transformation matrix
gml_pragma("forceinline");

var M, TR, T, S, Q, t, temp;
M = argument0;

//---------------Create orientation quaternion from the top left 3x3 part of the matrix
//Source: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
T = 1 + M[0] + M[5] + M[10]
if T > 0.00001{
    S = sqrt(T) * 2;
    Q[0] = (M[9] - M[6]) / S;
    Q[1] = (M[2] - M[8]) / S;
    Q[2] = (M[4] - M[1]) / S;
    Q[3] = -0.25 * S;} //I have modified this
else if ( M[0] > M[5] && M[0] > M[10] ){// Column 0: 
    S  = sqrt( 1.0 + M[0] - M[5] - M[10] ) * 2;
    Q[0] = 0.25 * S;
    Q[1] = (M[4] + M[1] ) / S;
    Q[2] = (M[2] + M[8] ) / S;
    Q[3] = (M[9] - M[6] ) / S;} 
else if ( M[5] > M[10] ){// Column 1: 
    S  = sqrt( 1.0 + M[5] - M[0] - M[10] ) * 2;
    Q[0] = (M[4] + M[1] ) / S;
    Q[1] = 0.25 * S;
    Q[2] = (M[9] + M[6] ) / S;
    Q[3] = (M[2] - M[8] ) / S;} 
else {// Column 2:
    S  = sqrt( 1.0 + M[10] - M[0] - M[5] ) * 2;
    Q[0] = (M[2] + M[8] ) / S;
    Q[1] = (M[9] + M[6] ) / S;
    Q[2] = 0.25 * S;
    Q[3] = (M[4] - M[1] ) / S;}


if Q[0] < 0
{
    Q[0] = -Q[0];
    Q[1] = -Q[1];
    Q[2] = -Q[2];
    Q[3] = -Q[3];
}

//---------------Create translation quaternion
T[0] = M[12];
T[1] = M[13];
T[2] = M[14];
T[3] = 0;
TR = smf_quat_multiply(T, Q)
for (var i = 0; i < 4; i ++){Q[i + 4] = TR[i] / 2}

return Q;
