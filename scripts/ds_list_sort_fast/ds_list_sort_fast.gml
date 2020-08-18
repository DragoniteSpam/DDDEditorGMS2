/// @param list
/// @param [value-get]
/// @param [l]
/// @param [r]
function ds_list_sort_fast() {
	// sorts by data.name instead of data

	var list = argument[0];
	var value = (argument_count > 1 && argument[1] != undefined) ? argument[1] : ds_get_value;
	var l = (argument_count > 2) ? argument[2] : 0;
	var r = (argument_count > 3) ? argument[3] : ds_list_size(list) - 1;

	if (l < r) {
	    var m = (l + r) div 2;
	    ds_list_sort_fast(list, value, l, m);
	    ds_list_sort_fast(list, value, m + 1, r);
	    ds_list_sort_fast__merge(list, l, m, r, value);
	}

	return list;


}
