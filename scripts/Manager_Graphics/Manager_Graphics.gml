function dmu_graphic_add_tileset_drag(element, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < array_length(filtered_list); i++) {
        import_texture(filtered_list[i]);
    }
}

function dmu_graphic_add_generic_drag(element, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < array_length(filtered_list); i++) {
        graphics_add_generic(filtered_list[i], element.root.graphics_prefix, element.root.el_list.entries, undefined, false);
    }
}