function dialog_create_settings_data_asset_files(dialog) {
    var dw = 960;
    var dh = 400;
    
    var dg = dialog_create(dw, dh, "Data and Asset Files", dialog_default, dialog_destroy, dialog);
    dg.file = undefined;
    
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
        var file_data = Game.meta.export.files[selection];
        list.root.file = file_data;
        if (file_data) {
            list.root.el_name.interactive = (selection > 0);
            list.root.el_compressed.interactive = true;
            list.root.el_types.interactive = true;
            list.root.el_critical.interactive = (selection > 0);
            list.root.el_compressed.value = file_data.compressed;
            list.root.el_critical.value = file_data.critical;
            // the first file in the list is special, and its name is just
            // whatever you give it when you save
            ui_input_set_value(list.root.el_name, (selection > 0) ? file_data.name : "");
            // pick out data types that go to this data file
            ui_list_deselect(list.root.el_types);
            for (var i = 0; i < array_length(Game.meta.export.locations); i++) {
                // the data belongs in the selected file if its location is set
                // to the file, or the file is unassigned and the selected file
                // is the master one
                if (Game.meta.export.locations[i] == selection) {
                    ui_list_select(list.root.el_types, i);
                }
            }
        } else {
            list.root.el_name.interactive = false;
            list.root.el_compressed.interactive = false;
            list.root.el_types.interactive = false;
            list.root.el_critical.interactive = false;
        }
    }, false, dg, Game.meta.export.files);
    el_list.tooltip = "This is the list of data / asset files you currently have linked to the project. The master file is special, is always critical and can't be renamed as it has the same name as the project by default.\n\nCompressed files are shown in blue. Non-critical files are denoted with an asterisk*.";
    el_list.entries_are = ListEntries.SCRIPT;
    el_list.evaluate_text = function(list, index) {
        var file_data = Game.meta.export.files[index];
        return (index ? (file_data.name + ".ddda") : "(master.dddd)") + (file_data.critical ? "" : "*");
    };
    el_list.render_colors = function(list, index) {
        var file_data = Game.meta.export.files[index];
        return file_data.compressed ? c_blue : c_black;
    };
    dg.el_list = el_list;
    yy += el_list.GetHeight() + spacing;
    
    var el_add = create_button(col1_x, yy, "Add File", ew, eh, fa_center, function(button) {
        var list_main = button.root.el_list;
        if (array_length(Game.meta.export.files) < 0xff) {
            var base_name = "data";
            var name = base_name;
            var n = 1;
            while (internal_name_get(name)) {
                name = base_name + string(n++);
            }
            array_push(Game.meta.export.files, new DataFile(name, false, false));
            button.interactive = (array_length(Game.meta.export.files) < 0xff);
            button.root.el_remove.interactive = (array_length(Game.meta.export.files) > 0x01);
        }
    }, dg);
    el_add.tooltip = "Add a data / asset file. You can have up to " + string(0xff) + ", which is realistically way the heck more than you'll need since there are only " + string(array_length(Game.meta.export.locations)) + " things you can put into them.";
    el_add.interactive = (array_length(Game.meta.export.files) < 0xff);
    dg.el_add = el_add;
    yy += el_add.height + spacing;
    
    var el_remove = create_button(col1_x, yy, "Delete File", ew, eh, fa_center, function(button) {
        var list_main = button.root.el_list;
        var selection = ui_list_selection(list_main);
        if (selection + 1 && array_length(Game.meta.export.files) > 0x01 && selection < array_length(Game.meta.export.files)) {
            var file_data = Game.meta.export.files[selection];
            array_delete(Game.meta.export.files, selection, 1);
            button.interactive = (array_length(Game.meta.export.files) > 0x01);
            button.root.el_add.interactive = (array_length(Game.meta.export.files) < 0xff);
            // any categories that previously lived in this file get set to the
            // master file; any that live in a succeeding file get shifted down
            for (var i = 0; i < array_length(Game.meta.export.locations); i++) {
                if (Game.meta.export.locations[i] == selection) {
                    Game.meta.export.locations[i] = 0;
                } else if (Game.meta.export.locations[i] > selection) {
                    Game.meta.export.locations[i]--;
                }
            }
            ui_list_deselect(list_main);
            ui_list_select(list_main, min(selection, array_length(Game.meta.export.files) - 1));
            list_main.onvaluechange(list_main);
        }
    }, dg);
    el_remove.tooltip = "Delete a data / asset file. You must have at least one. If you remove a data file that is still assigned to be used, anything that would have been saved to it will instead be saved to the one at the top of the list.";
    el_remove.interactive = (array_length(Game.meta.export.files) > 0x01);
    dg.el_remove = el_remove;
    yy += el_remove.height + spacing;
    
    yy = yy_start;
    
    var el_types = create_list(col2_x, yy, "Contents:", "", ew, eh, 10, function(list) {
        var list_main = list.root.el_list;
        var selection_main = ui_list_selection(list_main);
        var selection = ui_list_selection(list);
        if (selection_main + 1 && selection + 1) {
            Game.meta.export.locations[selection] = selection_main;
        }
    }, false, dg, ["Game Data", "Animations", "Data: Events", "Maps", "Terrain", "Images", "Audio", "Meshes", "Language Text"]);
    
    el_types.tooltip = "This is the list of all the types of stuff you can sort into different files. I recommend putting each of the audio / visual resources (colorized) into their own files, especially if you use source control, so that changing one doesn't cause the entire wad of data to have to be updated. The main game data must be in the master data file, since other things may depend on their existence.";
    el_types.auto_multi_select = true;
    el_types.allow_deselect = false;
    el_types.interactive = false;
    dg.el_types = el_types;
    yy += el_types.GetHeight() + spacing;
    
    yy = yy_start;
    
    var el_name = create_input(col3_x, yy, "Name:", ew, eh, function(input) {
        var list = input.root.el_list;
        var selection = ui_list_selection(list);
        var file_data/*:DataFile*/ = Game.meta.export.files[selection];
        if (file_data) file_data.Rename(input.value);
    }, "", "name", function(str, input) {
        if (string_length(str) == 0) return false;
        if (!validate_string_internal_name(str)) return false;
        if (input.value == input.root.file.name) return true;
        if (input.root.file) return input.root.file.ValidName(str);
        return true;
    }, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_name.tooltip = "The name of the data file. Names must be unique. (This shares the Internal Name scheme with other kinds of game data / assets, so you can't give a file the same name as an Animation or Mesh or anything either, but realistically you won't be trying to give any of these things the same name anyway.)";
    el_name.interactive = false;
    dg.el_name = el_name;
    yy += el_name.height + spacing;
    
    var el_compressed = create_checkbox(col3_x, yy, "Compressed?", ew, eh, function(checkbox) {
        var list = checkbox.root.el_list;
        var selection = ui_list_selection(list);
        if (selection + 1) {
            Game.meta.export.files[selection].compressed = checkbox.value;
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
            Game.meta.export.files[selection].critical = checkbox.value;
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