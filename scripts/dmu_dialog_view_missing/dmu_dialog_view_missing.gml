/// @param UIThing
function dmu_dialog_view_missing(argument0) {

	var button = argument0;

	if (file_exists(LOCAL_STORAGE + "missing.txt")) {
	    ds_stuff_open_local("missing.txt");
	} else {
	    dialog_create_notice(button, "No missing assets currently known. (That's a good thing!)");
	}

	dialog_destroy();
	dialog_destroy();
	dialog_destroy();


}
