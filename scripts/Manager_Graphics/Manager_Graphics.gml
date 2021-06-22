function dmu_graphic_export_generic(button) {
    var list = button.root.el_list;
    var selection = ui_list_selection(list);
    if (selection + 1) {
        var what = list.entries[selection];
        try {
            var fn = get_save_filename_image(what.name + ".png");
            sprite_save(what.picture, 0, fn);
            //ds_stuff_open(fn);
        } catch (e) {
            wtf("Could not save the image: " + e.message);
        }
    }
}

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


function dmu_graphic_delete_generic(button) {
    var list = button.root.el_list;
    var selection = ui_list_selection(list);
    ui_list_deselect(list);
    if (selection + 1) {
        var data = list.entries[selection];
        array_delete(list.entries, array_search(list.entries, data), 1);
        data.Destroy();
        ui_list_deselect(list);
        list.root.el_image.image = -1;
    }
}

function dmu_graphic_delete_tileset(button) {
    if (array_length(Game.graphics.tilesets) == 1) {
        return emu_dialog_notice("Please don't try to delete the last tileset. That would cause issues.");
    }
    dmu_graphic_delete_generic(button);
}

function dmu_graphic_add_tileset_drag(element, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < array_length(filtered_list); i++) {
        import_texture(filtered_list[i]);
    }
}

function dmu_graphic_add_tileset(button) {
    var fn = get_open_filename_image();
    if (file_exists(fn)) {
        tileset_create(fn, undefined);
    }
}

function dmu_graphic_add_generic(button) {
    var fn = get_open_filename_image();
    if (file_exists(fn)) {
        graphics_add_generic(fn, button.root.graphics_prefix, button.root.el_list.entries, undefined, false);
    }
}

function dmu_graphic_add_generic_drag(element, files) {
    var filtered_list = ui_handle_dropped_files_filter(files, [".png", ".bmp", ".jpg", ".jpeg"]);
    for (var i = 0; i < array_length(filtered_list); i++) {
        graphics_add_generic(filtered_list[i], element.root.graphics_prefix, element.root.el_list.entries, undefined, false);
    }
}