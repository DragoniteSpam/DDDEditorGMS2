/// @param list

var list = argument0;

var n = ds_list_clear_instances(list);
ds_list_destroy(list);

return n;