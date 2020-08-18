/// @param UIList
function ui_list_reset_view(argument0) {

	while (argument0.index > 0 && (argument0.index + argument0.slots) > ds_list_size(argument0.entries)) {
	    argument0.index--;
	}


}
