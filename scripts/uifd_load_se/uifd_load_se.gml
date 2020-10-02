function uifd_load_se(thing, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".wav"]);
    for (var i = 0; i < ds_list_size(filtered_list); i++) {
        var fn = filtered_list[| i];
        audio_add_se(fn);
    }
}