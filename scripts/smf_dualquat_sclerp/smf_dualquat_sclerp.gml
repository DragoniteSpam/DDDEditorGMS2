/// @description dualquat_sclerp(Q1, Q2, amount)
/// @param Q1
/// @param Q2
/// @param amount
function smf_dualquat_sclerp(argument0, argument1, argument2) {

    //THIS SCRIPT DOES NOT WORK PROPERLY




    Q1 = argument0;
    Q2 = argument1;
    t = argument2;

    // Shortest path
    if (smf_quat_dot(Q1, Q2) < 0){
        for (var i = 0; i < 8; i ++){Q2[i] *= -1;}}
     
    // ScLERP = qa(qa^-1 qb)^t
    diff = smf_dualquat_multiply(smf_dualquat_get_conjugate(Q1), Q2);
    vr[0] = diff[0];
    vr[1] = diff[1];
    vr[2] = diff[2];
    vd[0] = diff[4];
    vd[1] = diff[5];
    vd[2] = diff[6];
    var l = point_distance_3d(0, 0, 0, vr[0], vr[1], vr[2]);
    if l == 0{return Q1;}
    invR = 1 / l;

    //Screw parameters
    angle = 2 * arccos(diff[3]);
    pitch = -2 * diff[3] * invR;
    dir[0] = vr[0] * invR;
    dir[1] = vr[1] * invR;
    dir[2] = vr[2] * invR;
    moment[0] = (vd[0] - dir[0] * pitch * diff[3] * 0.5) * invR;
    moment[1] = (vd[1] - dir[1] * pitch * diff[3] * 0.5) * invR;
    moment[2] = (vd[2] - dir[2] * pitch * diff[3] * 0.5) * invR;
    
    // Exponential power
    angle *= t;
    pitch *= t;
    
    // Convert back to dual-quaternion
    sinAngle = sin(0.5 * angle);
    cosAngle = cos(0.5 * angle);

    R[0] = dir[0] * sinAngle;
    R[1] = dir[1] * sinAngle;
    R[2] = dir[2] * sinAngle;
    R[3] = cosAngle;

    R[4] = sinAngle * moment[0] + dir[0] * pitch * 0.5 * cosAngle;
    R[5] = sinAngle * moment[1] + dir[1] * pitch * 0.5 * cosAngle;
    R[6] = sinAngle * moment[2] + dir[2] * pitch * 0.5 * cosAngle;
    R[7] = -pitch * 0.5 * sinAngle;

    // Complete the multiplication and return the interpolated value
    return smf_dualquat_multiply(Q1, R);


}
