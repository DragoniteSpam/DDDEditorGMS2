/// @description smf_path_get_number
/// @param path
function smf_path_get_number(argument0) {
	return ds_list_size(SMF_pathList[| argument0]) / 2;


}
