/// @description  int ds_list_destroy_instances_indirect(list);
/// @param list
// because there are some instances which automatically remove themselves
// from the list that you want to pass to this script, and doing this the
// easy way will cause the program to break

var n=ds_list_size(argument0);
var pending=ds_list_create();
ds_list_copy(pending, argument0);
for (var i=0; i<ds_list_size(pending); i++){
    instance_activate_object(pending[| i]);
    instance_destroy(pending[| i]);
}
ds_list_destroy(pending);
ds_list_destroy(argument0);

return n;
