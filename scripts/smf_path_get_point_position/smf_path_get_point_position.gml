/// @description smf_path_get_point_position(path, index)
/// @param path
/// @param index
function smf_path_get_point_position(argument0, argument1) {
    return ds_list_find_value(SMF_pathList[| argument0], argument1 * 2 + 1);


}
