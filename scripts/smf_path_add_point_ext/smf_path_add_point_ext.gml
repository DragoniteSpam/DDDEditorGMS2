/// @description smf_path_add_point(pathIndex, M[16], position)
/// @param pathIndex
/// @param M[16]
/// @param position
var pth = SMF_pathList[| argument0];
var M = argument1;
var length = argument2;
ds_list_add(pth, M, length);

SMF_pathList[| argument0 + 2] = length;
if smf_path_get_closed(argument0)
{
	first = ds_list_find_value(pth, 0);
	SMF_pathList[| argument0 + 2] += point_distance_3d(first[SMF_X], first[SMF_Y], first[SMF_Z], M[SMF_X], M[SMF_Y], M[SMF_Z]);
}
return ds_list_size(pth) - 2;