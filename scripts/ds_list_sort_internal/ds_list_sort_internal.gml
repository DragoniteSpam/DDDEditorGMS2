/// @param list
/// @param [l]
/// @param [r]
// sorts by data.name instead of data

var list = argument[0];
var l = (argument_count > 1) ? argument[1] : 0;
var r = (argument_count > 2) ? argument[2] : ds_list_size(list) - 1;

return ds_list_sort_fast(list, ds_get_internal_name, l, r);