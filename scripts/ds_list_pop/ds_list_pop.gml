/// @param list
// for when you want to be using a stack, but need to
// do stuff with it that you need a list for.

var list = argument0;
var n = ds_list_size(list) - 1;
var value = list[| n];
ds_list_delete(list, n);

return value;