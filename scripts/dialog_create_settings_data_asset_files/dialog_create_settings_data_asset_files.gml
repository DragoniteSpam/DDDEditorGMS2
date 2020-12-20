function dialog_create_settings_data_asset_files(dialog) {
    var dw = 960;
    var dh = 400;
    
    var dg = dialog_create(dw, dh, "Data and Asset Files", dialog_default, dc_close_no_questions_asked, dialog);
    
    var columns = 3;
    var ew = dw / columns - 32 * columns;
    var eh = 24;
    
    var vx1 = ew / 3;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var spacing = 16;
    var col1_x = spacing;
    var col2_x = dw / columns + spacing;
    var col3_x = 2 * dw / columns + spacing;
    
    var yy = 64;
    var yy_start = 64;
    
    var el_list = create_list(col1_x, yy, "Asset Files", "", ew, eh, 8, function(list) {
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var file_data = list.entries[| selection];
            list.root.el_name.interactive = (selection > 0);
            list.root.el_compressed.interactive = true;
            list.root.el_types.interactive = true;
            list.root.el_critical.interactive = (selection > 0);
            list.root.el_compressed.value = file_data.compressed;
            list.root.el_critical.value = file_data.critical;
            // the first file in the list is special, and its name is just whatever you give it when you save
            if (selection) {
                list.root.el_name.interactive = true;
                ui_input_set_value(list.root.el_name, file_data.internal_name);
            }
            // pick out data types that go to this data file
            ui_list_deselect(list.root.el_types);
            for (var i = 0; i < array_length(Stuff.game_data_location); i++) {
                // the first three get special treatment
                if (i < 3) {
                    if (selection == 0) {
                        ui_list_select(list.root.el_types, i);
                    }
                    continue;
                }
                // otherwise, the data belongs in the selected file if its location is set to the file's GUID,
                // or the file is unassigned and the selected file is the master one
                if (Stuff.game_data_location[i] == file_data.GUID) {
                    ui_list_select(list.root.el_types, i);
                } else if (selection == 0 && !guid_get(Stuff.game_data_location[i])) {
                    ui_list_select(list.root.el_types, i);
                }
            }
        } else {
            list.root.el_name.interactive = false;
            list.root.el_compressed.interactive = false;
            list.root.el_types.interactive = false;
            list.root.el_critical.interactive = false;
        }
    }, false, dg, Stuff.game_asset_lists);
    el_list.tooltip = "This is the list of data / asset files you currently have linked to the project. The master file is special, is always critical and can't be renamed as it has the same name as the project by default.\n\nCompressed files are shown in blue. Non-critical files are denoted with an asterisk*."
    el_list.entries_are = ListEntries.SCRIPT;
    el_list.evaluate_text = ui_list_text_asset_files;
    el_list.render_colors = ui_list_colors_asset_files;
    dg.el_list = el_list;
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(col1_x, yy, "Add File", ew, eh, fa_center, function(button) {
        var list_main = button.root.el_list;
        if (ds_list_size(list_main.entries) < 0xff) {
            var base_name = "data";
            var name = base_name;
            var n = 1;
            while (internal_name_get(name)) {
                name = base_name + string(n++);
            }
            ds_list_add(list_main.entries, create_data_file(name, false));
            button.interactive = (ds_list_size(list_main.entries) < 0xff);
            button.root.el_remove.interactive = (ds_list_size(list_main.entries) > 0x01);
        }
    }, dg);
    el_add.tooltip = "Add a data / asset file. You can have up to " + string(0xff) + ", which is realistically way the heck more than you'll need since there are only " + string(array_length(Stuff.game_data_location)) + " things you can sort into them.";
    el_add.interactive = (ds_list_size(Stuff.game_asset_lists) < 0xff);
    dg.el_add = el_add;
    yy += el_add.height + spacing;
    
    var el_remove = create_button(col1_x, yy, "Delete File", ew, eh, fa_center, function(button) {
        var list_main = button.root.el_list;
        var selection = ui_list_selection(list_main);
        if (selection + 1 && ds_list_size(list_main.entries) > 0x01 && selection < ds_list_size(list_main.entries)) {
            var file_data = list_main.entries[| selection];
            ds_list_delete(list_main.entries, selection);
            instance_activate_object(file_data);
            instance_destroy(file_data);
            button.interactive = (ds_list_size(list_main.entries) > 0x01);
            button.root.el_add.interactive = (ds_list_size(list_main.entries) < 0xff);
        }
    }, dg);
    el_remove.tooltip = "Delete a data / asset file. You must have at least one. If you remove a data file that is still assigned to be used, anything that would have been saved to it will instead be saved to the one at the top of the list.";
    el_remove.interactive = (ds_list_size(Stuff.game_asset_lists) > 0x01);
    dg.el_remove = el_remove;
    yy += el_remove.height + spacing;
    
    yy = yy_start;
    
    var el_types = create_list(col2_x, yy, "Contents:", "", ew, eh, 10, function(list) {
        var list_main = list.root.el_list;
        var selection_main = ui_list_selection(list_main);
        if (selection_main + 1) {
            var file_data = list_main.entries[| selection_main];
            for (var i = 0; i < ds_list_size(list.entries); i++) {
                // the first three types will always be in the main data file, and will never be moved
                if (i < 3) {
                    if (selection_main == 0) {
                        ui_list_select(list, i);
                    } else {
                        ds_map_delete(list.selected_entries, i);
                    }
                    continue;
                }
                // otherwise, if a thing is selected, assign it
                if (ui_list_is_selected(list, i)) {
                    Stuff.game_data_location[i] = file_data.GUID;
                }
            }
        }
    }, false, dg);
    create_list_entries(el_types,
        ["Data: Datadata", c_gray], ["Data: Instances", c_gray],  ["Data: Global", c_gray],
        ["Data: Animations", c_black], ["Data: Events", c_black],
        ["Terrain", c_black], ["Maps", c_black],
        ["Image: Autotiles", c_blue], ["Image: Tilesets", c_blue],
        ["Image: Battlers", c_blue], ["Image: Overworlds", c_blue],
        ["Image: Particles", c_blue], ["Image: UI", c_blue],
        ["Image: Skybox", c_blue], ["Image: Misc.", c_blue],
        ["Audio: BGM", c_purple], ["Audio: SE", c_purple],
        ["Meshes", c_green], ["Mesh Autotiles", c_green],
        ["Language Text", c_black],
    );
    el_types.tooltip = "This is the list of all the types of stuff you can sort into different files. I recommend putting each of the audio / visual resources (colorized) into their own files, especially if you use source control, so that changing one doesn't cause the entire wad of data to have to be updated. The main game data must be in the master data file, since other things may depend on their existence.";
    el_types.auto_multi_select = true;
    el_types.interactive = false;
    dg.el_types = el_types;
    yy += ui_get_list_height(el_types) + spacing;
    
    yy = yy_start;
    
    var el_name = create_input(col3_x, yy, "Name:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var file_data = list.entries[| selection];
            internal_name_set(file_data, input.value, false, true);
        }
    }, "", "name", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "The name of the data file. Names must be unique. (This shares the Internal Name scheme with other kinds of game data / assets, so you can't give a file the same name as an Animation or Mesh or anything either, but realistically you won't be trying to give any of these things the same name anyway.)";
    el_name.interactive = false;
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var el_compressed = create_checkbox(col3_x, yy, "Compressed?", ew, eh, function(checkbox) {
        var list = checkbox.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var file_data = list.entries[| selection];
            file_data.compressed = checkbox.value;
        }
    }, false, dg);
    el_compressed.tooltip = "Whether or not the data file should be compressed. Compressing files allows them to take up less space, but makes them take longer to load.";
    el_compressed.interactive = false;
    dg.el_compressed = el_compressed;
    yy += el_compressed.height + spacing;
    
    var el_critical = create_checkbox(col3_x, yy, "Critical?", ew, eh, function(checkbox) {
        var list = checkbox.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            var file_data = list.entries[| selection];
            file_data.critical = checkbox.value;
        }
    }, false, dg);
    el_critical.tooltip = "The game is programmed to complain if any of its asset files can't be found, but in some cases (i.e. files containing Terrain) this may not be necessary and you can choose to ignore them. Note that this only affects how the game itself handles the data files; non-critical files are still needed by the editor.";
    el_critical.interactive = false;
    dg.el_critical = el_critical;
    yy += el_critical.height + spacing;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        // list
        el_list,
        el_add,
        el_remove,
        // types
        el_types,
        // specifications
        el_name,
        el_compressed,
        el_critical,
        // confirm
        el_confirm
    );
    
    return dg;
}