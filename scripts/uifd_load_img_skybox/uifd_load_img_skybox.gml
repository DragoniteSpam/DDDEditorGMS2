function uifd_load_img_skybox(thing, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < ds_list_size(filtered_list); i++) {
        graphics_add_generic(filtered_list[| i], PREFIX_GRAPHIC_SKYBOX, thing.root.el_list.entries);
    }
}