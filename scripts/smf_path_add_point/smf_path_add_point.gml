/// @description smf_path_add_point(pathIndex, M[16])
/// @param pathIndex
/// @param M[16]
function smf_path_add_point(argument0, argument1) {
	var pth = argument0;
	var M = argument1;
	var num = smf_path_get_number(argument0);
	var position = 0;
	if num > 0
	{
	    position = smf_path_get_point_position(pth, num - 1);
	    prevPoint = smf_path_get_point(argument0, num - 1);
	    position += point_distance_3d(prevPoint[SMF_X], prevPoint[SMF_Y], prevPoint[SMF_Z], M[SMF_X], M[SMF_Y], M[SMF_Z]);
	}
	return smf_path_add_point_ext(pth, M, position);


}
