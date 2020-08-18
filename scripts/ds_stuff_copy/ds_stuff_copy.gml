/// @description double ds_stuff_copy(source, destination);
/// @param source
/// @param destination
function ds_stuff_copy(argument0, argument1) {

	/*
	 * Copies a file from the source to the destination
	 */

	return external_call(global._ds_stuff_copy, argument0, argument1);



}
