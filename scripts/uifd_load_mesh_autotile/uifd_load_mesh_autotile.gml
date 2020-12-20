function uifd_load_mesh_autotile(thing, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj"]);
    for (var i = 0; i < ds_list_size(filtered_list); i++) {
        var fn = filtered_list[| i];
        switch (filename_ext(fn)) {
            default:
        }
    }
}