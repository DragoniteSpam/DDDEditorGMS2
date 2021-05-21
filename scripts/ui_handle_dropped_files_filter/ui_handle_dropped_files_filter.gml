function ui_handle_dropped_files_filter(files, extensions) {
    var filtered_list = [];
    var extension_map = { };
    
    for (var j = 0; j < array_length(extensions); j++) {
        extension_map[$ string_lower(extensions[j])] = true;
    }
    
    for (var i = 0; i < array_length(files); i++) {
        var fn = string_lower(files[i]);
        if (extension_map[$ filename_ext(fn)]) {
            array_push(filtered_list, fn);
        }
    }
    
    return filtered_list;
}