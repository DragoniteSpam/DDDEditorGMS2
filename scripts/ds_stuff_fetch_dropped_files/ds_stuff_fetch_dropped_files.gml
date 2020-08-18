function ds_stuff_fetch_dropped_files() {
	var n = external_call(global._ds_stuff_file_drop_count);
	var array = array_create(n);

	for (var i = 0; i < n; i++) {
	    array[i] = external_call(global._ds_stuff_file_drop_get, i);
	}

	external_call(global._ds_stuff_file_drop_flush);

	return array;


}
