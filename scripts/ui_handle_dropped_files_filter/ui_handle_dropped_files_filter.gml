function ui_handle_dropped_files_filter(files, extensions) {
    var filtered_list = [];
    
    for (var j = 0; j < array_length(extensions); j++) {
        extensions[j] = string_lower(extensions[j]);
    }
    
    for (var i = 0; i < array_length(files); i++) {
        var fn = string_lower(files[i]);
        for (var j = 0; j < array_length(extensions); j++) {
            if (filename_ext(fn) == extensions[j]) {
                array_push(filtered_list, fn);
            }
        }
    }
    
    return filtered_list;
}