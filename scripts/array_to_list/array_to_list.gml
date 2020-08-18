/// @description ds_list array_to_list(array);
/// @param array
function array_to_list(argument0) {

	var list=ds_list_create();
	for (var i=0; i<array_length_1d(argument0); i++) {
	    ds_list_add(list, argument0[@ i]);
	}

	return list;



}
