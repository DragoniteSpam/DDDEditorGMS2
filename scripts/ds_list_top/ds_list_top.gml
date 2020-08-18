/// @description value ds_list_top(list);
/// @param list
function ds_list_top(argument0) {
	// for when you want to be using a stack, but need to
	// do stuff with it that you need a list for.

	return argument0[| ds_list_size(argument0)-1];



}
