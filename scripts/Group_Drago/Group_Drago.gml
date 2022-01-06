drago_init(window_handle(), true);

function drago_get_dropped_files() {
	var n = __file_dropper_count();
	var array = array_create(n);
    
	for (var i = 0; i < n; i++) {
	    array[i] = __file_dropper_get(i);
	}
    
    file_dropper_flush();    
    array_sort(array, true);
    
	return array;
}