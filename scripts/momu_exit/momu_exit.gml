/// @param MenuElement
function momu_exit(argument0) {

	var menu = argument0;

	var dg = dialog_create_yes_or_no(noone, "Do you want to close the program?", dmu_dialog_quit);
	dg.dialog_flags |= DialogFlags.IS_QUIT;


}
