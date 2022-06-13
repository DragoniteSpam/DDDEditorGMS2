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
        static write_header = function(buffer) {
            buffer_write(buffer, buffer_u8, $44);
            buffer_write(buffer, buffer_u8, $44);
            buffer_write(buffer, buffer_u8, $44);
            buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
        };
        
        static write_index = function(buffer) {
            // sign the first one
            buffer_write(buffer, buffer_string, Game.meta.project.author);
            buffer_write(buffer, buffer_string, Game.meta.project.summary);
            buffer_write(buffer, buffer_flag, Game.meta.export.flags);
            // minus one because index zero is assumed to be the master file
            buffer_write(buffer, buffer_u8, array_length(Game.meta.export.files) - 1);
            // start at 1 because we kinda already know to load the main data file
            for (var j = 1; j < array_length(Game.meta.export.files); j++) {
                var asset_file = Game.meta.export.files[j];
                buffer_write(buffer, buffer_string, asset_file.name);
                buffer_write(buffer, buffer_field, pack(
                    asset_file.critical
                ));
            }
        };
        
        var game_data_save_scripts = array_create(GameDataCategories.__COUNT);
        game_data_save_scripts[GameDataCategories.IMAGES] =                     project_export_images;
        game_data_save_scripts[GameDataCategories.AUDIO] =                      project_export_audio;
        game_data_save_scripts[GameDataCategories.MESHES] =                     project_export_meshes;
        game_data_save_scripts[GameDataCategories.MAPS] =                       project_export_maps;
        game_data_save_scripts[GameDataCategories.EVENTS]  =                    project_export_events;
        game_data_save_scripts[GameDataCategories.DATA] =                       project_export_data;
        game_data_save_scripts[GameDataCategories.ANIMATIONS] =                 project_export_animations;
        game_data_save_scripts[GameDataCategories.TERRAIN] =                    project_export_terrain;
        game_data_save_scripts[GameDataCategories.LANGUAGE_TEXT] =              project_export_language;
        
        var fn = get_save_filename_dddd(Stuff.save_name);
        
        if (string_length(fn) > 0) {
            debug_timer_start();
            
            var save_directory = filename_path(fn);
            var buffers = array_create(array_length(Game.meta.export.files));
            
            var map_index = 0;
            var map_file_prefix = save_directory + filename_change_ext(filename_name(fn), "");
            var map_buffer = buffer_create(0x10000, buffer_grow, 1);
            for (var i = 0, n = array_length(Game.maps); i < n; i++) {
                Game.maps[i].ExportMapContents(map_buffer, map_index);
                if (buffer_tell(map_buffer) > 0x80000000) {                     // 2 GB map file size limit
                    buffer_save_ext(map_buffer, map_file_prefix + string(map_index++) + EXPORT_EXTENSION_MAP, 0, buffer_tell(map_buffer));
                    buffer_delete(map_buffer);
                    map_buffer = buffer_create(0x10000, buffer_grow, 1);
                }
            }
            buffer_save_ext(map_buffer, map_file_prefix + string(map_index++) + EXPORT_EXTENSION_MAP, 0, buffer_tell(map_buffer));
            buffer_delete(map_buffer);
            
            for (var i = 0; i < array_length(Game.meta.export.files); i++) {
                var file_data = Game.meta.export.files[i];
                var this_files_name = save_directory + file_data.name + EXPORT_EXTENSION_ASSETS;
                var buffer = buffer_create(1024, buffer_grow, 1);
                write_header(buffer);
                
                if (i == 0) {
                    write_index(buffer);
                }
                
                // generate a list of all of the things that are in this file
                for (var j = 0; j < array_length(Game.meta.export.locations); j++) {
                    // the files that are sorted
                    if (Game.meta.export.locations[j] == i) {
                        buffer_write(buffer, buffer_u32, j);
                        game_data_save_scripts[j](buffer);
                    }
                }
                buffer_write(buffer, buffer_u32, buffer_eof);
                
                // the default file should have the global settings
                // (including a list of all of the other files)
                if (i == 0) {
                    project_export_global(buffer);
                    this_files_name = fn;
                }
                
                if (file_data.compressed) {
                    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
                    buffer_save_ext(compressed, this_files_name, 0, buffer_get_size(compressed));
                    buffer_delete(compressed);
                } else {
                    buffer_save_ext(buffer, this_files_name, 0, buffer_tell(buffer));
                }
                
                buffer_delete(buffer);
            }
            
            Stuff.AddStatusMessage("Exporting project \"" + Stuff.save_name + "\" took " + debug_timer_finish());
        }
        
        #macro LAST_SAFE_VERSION DataVersions.V2
        enum DataVersions {
            V2                                  = 200, /* 24 jun 2021 */
            _CURRENT /* = whatever the last one is + 1 */
        }
    };
    
    switch (Settings.hide_warnings[$ warn_untranslated_strings]) {
        case undefined:
            if (untranslated) {
                var dialog = new EmuDialog(560, 320, "Hey!");
                dialog.function_export = fn_export;
                dialog.contents_interactive = true;
                var element_width = dialog.width - 64;
                var element_height = 32;
                
                return dialog.AddContent([
                    new EmuText(32, EMU_AUTO, element_width, 64, "Found " + string(untranslated) + " untranslated strings. Would you like to export the data without the text or export with the default strings? (Exporting as-is is probably fine as long as you remember to do this later.)"),
                    (new EmuRadioArray(32, EMU_AUTO, element_width, element_height, "Action:", 0, emu_null))
                        .AddOptions(["Export as is", "Export defaults"])
                        .SetID("ACTION"),
                    (new EmuCheckbox(32, EMU_AUTO, element_width, element_height, "Remember this choice", false, emu_null))
                        .SetID("REMEMBER")
                ])
                    .AddDefaultConfirmCancelButtons("Export", function() {
                        if (self.GetSibling("ACTION").value == 0) {
                            if (self.GetSibling("REMEMBER").value) {
                                Settings.hide_warnings[$ warn_untranslated_strings] = warn_untranslated_strings_as_is;
                            }
                            self.root.function_export();
                            emu_dialog_close_auto();
                        } else if (value == 1) {
                            if (self.GetSibling("REMEMBER").value) {
                                Settings.hide_warnings[$ warn_untranslated_strings] = warn_untranslated_strings_as_default;
                            }
                            language_set_default_text();
                            self.root.function_export();
                            emu_dialog_close_auto();
                        }
                    }, "Cancel", emu_dialog_close_auto);
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