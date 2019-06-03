/// @description value ds_list_pop(list);
/// @param list
// for when you want to be using a stack, but need to
// do stuff with it that you need a list for.

var n=ds_list_size(argument0)-1;
var value=argument0[| n];
ds_list_delete(argument0, n);

return value;
