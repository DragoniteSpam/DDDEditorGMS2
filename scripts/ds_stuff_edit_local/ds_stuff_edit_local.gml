/// @param file
function ds_stuff_edit_local(argument0) {

	// returns the ID of the process

	/*
	 * Used for editing files in the game's local storage. For stuff in the
	 * game's file bundle, see ds_stuff_open. (It also documents the return
	 * codes and stuff.)
	 *
	 * When opening stuff with this script, don't pass it the leading dot
	 * or the double backslash ("file.txt" isntead of ".\\file.txt").
	 */

	return ds_stuff_edit(LOCAL_STORAGE + argument0);


}
