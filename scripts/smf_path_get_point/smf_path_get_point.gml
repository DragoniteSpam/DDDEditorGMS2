/// @description smf_path_get_point(path, index)
/// @param path
/// @param index
function smf_path_get_point(argument0, argument1) {
	return ds_list_find_value(SMF_pathList[| argument0], argument1 * 2);


}
