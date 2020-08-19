/// @description smf_path_delete_point
/// @param pathIndex
/// @param pointIndex
function smf_path_delete_point(argument0, argument1) {
    var pth = SMF_pathList[| argument0];
    ds_list_delete(pth, argument1 * 2);
    ds_list_delete(pth, argument1 * 2);


}
