/// @description smf_path_get_position(pathIndex, position)
/// @param pathIndex
/// @param position
/// returns a vec3
function smf_path_get_position(argument0, argument1) {
    var a, b, A, B, aPos, bPos, i, pth, position, pthIndex, pthNum, closed, length, amount, linPth;
    pthIndex = argument0;
    position = argument1;
    pth = SMF_pathList[| pthIndex]
    closed = smf_path_get_closed(pthIndex);
    length = smf_path_get_length(pthIndex);
    pthNum = smf_path_get_number(pthIndex) - 1;
    if pthNum == 0{return -1;}
    if closed or position != 1{position = frac(position);}
    a = floor(position * pthNum);
    position *= length;
    repeat pthNum
    {
        aPos = smf_path_get_point_position(pthIndex, a);
        if position < aPos{a --; continue;}
        if closed{b = (a + 1) mod pthNum;}
        else{b = min(a + 1, pthNum - 1);}
        bPos = smf_path_get_point_position(pthIndex, b);
        if b == 0{bPos += length;}
        if position > bPos{a ++; continue;}
        amount = (position - aPos) / (bPos - aPos);
        A = smf_path_get_point(pthIndex, a);
        B = smf_path_get_point(pthIndex, b);
        return [lerp(A[SMF_X], B[SMF_X], amount), lerp(A[SMF_Y], B[SMF_Y], amount), lerp(A[SMF_Z], B[SMF_Z], amount)];
    }


}
