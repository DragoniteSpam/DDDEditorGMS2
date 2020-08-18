/// @description smf_path_get_matrix(pathIndex, position)
/// @param pathIndex
/// @param position
/// returns 4x4 matrix
function smf_path_get_matrix(argument0, argument1) {
	var a, b, A, B, R, aPos, bPos, i, pth, position, pthNum, closed, length, amount;
	pth = argument0;
	position = argument1;
	pthNum = smf_path_get_number(pth) - 1;
	closed = smf_path_get_closed(pth);
	length = smf_path_get_length(pth);
	if pthNum == 0{return -1;}
	if closed or position != 1{position = frac(position);}
	a = floor(position * pthNum);
	position *= length;
	repeat pthNum
	{
	    aPos = smf_path_get_point_position(pth, a);
	    if position < aPos{a --; continue;}
	    if closed{b = (a + 1) mod pthNum;}
	    else{b = min(a + 1, pthNum - 1);}
	    bPos = smf_path_get_point_position(pth, b);
	    if b == 0{bPos += length;}
	    if position > bPos{a ++; continue;}
	    amount = (position - aPos) / (bPos - aPos);
	    A = smf_path_get_point(pth, a);
	    B = smf_path_get_point(pth, b);
	    R = smf_array_lerp(A, B, amount);
	    smf_matrix_orthogonalize(R);
	    return R;
	}


}
