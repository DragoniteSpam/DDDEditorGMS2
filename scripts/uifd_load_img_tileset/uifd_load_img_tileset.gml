function uifd_load_img_tileset(thing, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < ds_list_size(filtered_list); i++) {
        import_texture(filtered_list[| i]);
    }
}