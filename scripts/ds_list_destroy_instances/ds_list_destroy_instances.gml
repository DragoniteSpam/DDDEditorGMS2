/// @param list
function ds_list_destroy_instances(argument0) {

	var list = argument0;

	var n = ds_list_clear_instances(list);
	ds_list_destroy(list);

	return n;


}
