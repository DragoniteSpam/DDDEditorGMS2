/// @param files[]
/// @param extensions[]
function ui_handle_dropped_files_filter(argument0, argument1) {

	var files = argument0;
	var extensions = argument1;

	var filtered_list = ds_list_create();

	for (var j = 0; j < array_length_1d(extensions); j++) {
	    extensions[j] = string_lower(extensions[j]);
	}

	for (var i = 0; i < array_length_1d(files); i++) {
	    var fn = string_lower(files[i]);
	    for (var j = 0; j < array_length_1d(extensions); j++) {
	        if (filename_ext(fn) == extensions[j]) {
	            ds_list_add(filtered_list, fn);
	        }
	    }
	}

	return filtered_list;


}
