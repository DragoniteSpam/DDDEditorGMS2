function project_export() {
    language_extract();
    var untranslated = 0;
    var lang_keys = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        var lang = Game.languages.text[$ Game.languages.names[i]];
        for (var j = 0; j < array_length(lang_keys); j++) {
            untranslated += (lang[$ lang_keys[j]] == "");
        }
    }
    
    static fn_export = function() {
        var fn = get_save_filename_dddd(Stuff.save_name);
        
        if (string_length(fn) > 0) {
            var save_directory = filename_path(fn);
            var buffers = array_create(array_length(Game.meta.export.files));
            
            Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
            var proj_name = filename_change_ext(filename_name(fn), "");
            
            game_auto_title();
            
            for (var i = 0; i < array_length(Game.meta.export.files); i++) {
                var file_data = Game.meta.export.files[i];
                var buffer = buffer_create(1024, buffer_grow, 1);
                serialize_save_header(buffer, file_data, (i == 0));
                
                // the default file should have a list of all of the other files
                if (i == 0) {
                    buffer_write(buffer, buffer_u8, array_length(Game.meta.export.files));
                    for (var j = 0; j < array_length(Game.meta.export.files); j++) {
                        var asset_file = Game.meta.export.files[j];
                        var bools = pack(asset_file.critical);
                        buffer_write(buffer, buffer_string, asset_file.name);
                        buffer_write(buffer, buffer_u32, bools);
                    }
                }
                
                // generate a list of all of the things that are in this file
                var contents = [];
                for (var j = 0; j < array_length(Game.meta.export.locations); j++) {
                    // the files that are sorted
                    if (Game.meta.export.locations[j] == file_data) {
                        array_push(contents, j);
                    }
                    // any data categories that aren't sorted into files go to the default
                    if (i == 0 && !Game.meta.export.locations[j]) {
                        array_push(contents, j);
                    }
                }
                
                // okay now you can *actually* write out the addresses of all the things
                // there's no need to save the size here because it reads until the EOF
                for (var j = 0; j < array_length(contents); j++) {
                    var addr = Stuff.game_data_save_scripts[contents[j]](buffer);
                }
                
                buffer_write(buffer, buffer_u32, SerializeThings.END_OF_FILE);
                
                var this_files_name = (i == 0) ? fn : (save_directory + file_data.name + EXPORT_EXTENSION_ASSETS);
                
                if (file_data.compressed) {
                    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
                    buffer_save_ext(compressed, this_files_name, 0, buffer_get_size(compressed));
                    setting_project_create_local(proj_name, filename_name(this_files_name), compressed);
                    buffer_delete(compressed);
                } else {
                    buffer_save_ext(buffer, this_files_name, 0, buffer_tell(buffer));
                    setting_project_create_local(proj_name, filename_name(this_files_name), buffer);
                }
                
                buffer_delete(buffer);
            }
        }
        
        #macro LAST_SAFE_VERSION DataVersions.MESH_TEXTURE_SCALE
        enum DataVersions {
            MESH_TEXTURE_SCALE                  = 125, /* 18 may 2021 */
            NO_EDITOR_DATA                      = 126, /* 29 may 2021 */
            _CURRENT /* = whatever the last one is + 1 */
        }
    };
    
    switch (Settings.hide_warnings[$ warn_untranslated_strings]) {
        case undefined:
            if (untranslated) {
                var dw = 560;
                var dh = 320;
                var b_width = 128;
                var b_height = 32;
                // IF/WHEN YOU EVER CONVERT THIS TO EMU make sure you also copy the reference to the export function
                var dg = dialog_create(dw, dh, "Hey!", dialog_default, function(button) { dialog_destroy(); }, undefined);
                dg.fn_export = fn_export;
                
                var el_text = create_text(32, 64, "Found " + string(untranslated) + " untranslated strings. Would you like to export the data without the text, export with the default strings, or cancel? (Exporting as-is is probably fine as long as you remember to do this later.)", dw - 64, 96, fa_left, dw - 64, dg);
                el_text.valignment = fa_top;
                var el_remember = create_checkbox(32, el_text.y + el_text.height + 32, "Remember this option", dw - 96, 32, null, false, dg);
                dg.el_remember = el_remember;
                var el_cancel = create_button(dw / 4 - b_width / 2, dh - 32 - b_height / 2, "Cancel export", b_width, b_height, fa_center, function(button) {
                    dialog_destroy();
                }, dg);
                var el_confirm_as_is = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Export as-is", b_width, b_height, fa_center, function(button) {
                    if (button.root.el_remember.value) {
                        Settings.hide_warnings[$ warn_untranslated_strings] = warn_untranslated_strings_as_is;
                    }
                    button.root.fn_export();
                    dialog_destroy();
                }, dg);
                var el_confirm_default = create_button(dw * 3 / 4 - b_width / 2, dh - 32 - b_height / 2, "Export defaults", b_width, b_height, fa_center, function(button) {
                    if (button.root.el_remember.value) {
                        Settings.hide_warnings[$ warn_untranslated_strings] = warn_untranslated_strings_as_default;
                    }
                    language_set_default_text();
                    button.root.fn_export();
                    dialog_destroy();
                }, dg);
                
                ds_list_add(dg.contents, el_text, el_remember, el_cancel, el_confirm_as_is, el_confirm_default);
            } else {
                fn_export();
            }
            break;
        case warn_untranslated_strings_as_default:
            language_set_default_text();
            fn_export();
            break;
        case warn_untranslated_strings_as_is:
            fn_export();
            break;
    }
}