/// @description smf_path_create(closed)
/// @param closed
var index = ds_list_size(SMF_pathList);
var pth = ds_list_create();
var closed = argument0;
var length = 0;
ds_list_add(SMF_pathList, pth, closed, length);
return index;