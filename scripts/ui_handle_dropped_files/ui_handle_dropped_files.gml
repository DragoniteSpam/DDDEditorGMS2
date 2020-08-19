/// @param UIThing
function ui_handle_dropped_files(argument0) {

	var thing = argument0;

	if (array_length(Stuff.files_dropped) > 0) {
	    script_execute(thing.file_dropper_action, thing, Stuff.files_dropped);
	}


}
