/// @param list
function ds_list_clone(argument0) {
	// this doesn't really do anything special, it just makes ds_list_copy slightly shorter

	var list = ds_list_create();
	ds_list_copy(list, argument0);

	return list;


}
