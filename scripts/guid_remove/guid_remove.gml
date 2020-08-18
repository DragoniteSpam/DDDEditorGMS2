/// @param guid
function guid_remove(argument0) {

	if (ds_map_exists(Stuff.all_guids, argument0)) {
	    ds_map_delete(Stuff.all_guids, argument0);
	    return true;
	}

	return false;


}
