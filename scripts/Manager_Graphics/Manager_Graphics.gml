function dmu_graphic_change_generic(button) {
    var list = button.root.el_list;
    var selection = ui_list_selection(list);
    if (selection + 1) {
        var fn = get_open_filename_image();
        if (file_exists(fn)) {
            var data = list.entries[selection];
            sprite_delete(data.picture);
            data.picture = sprite_add(fn, 0, false, false, 0, 0);
            data_image_force_power_two(data);
            data_image_npc_frames(data);
            list.onvaluechange(list);
        }
    }
}

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