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
        }
        
        static game_data_save_scripts = array_create(GameDataCategories.__COUNT);
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
            var t0 = get_timer();
            
            var save_directory = filename_path(fn);
            var buffers = array_create(array_length(Game.meta.export.files));
            
            var map_index = 0;
            var map_buffer = buffer_create(0x10000, buffer_grow, 1);
            for (var i = 0; i < array_length(Game.maps); i++) {
                Game.maps[i].ExportMapContents(map_buffer, map_index);
                if (buffer_tell(map_buffer) > 0x80000000) {                     // 2 GB map file size limit
                    buffer_save_ext(map_buffer, save_directory + string(map_index++) + EXPORT_EXTENSION_MAP, 0, buffer_tell(map_buffer));
                    buffer_delete(map_buffer);
                    map_buffer = buffer_create(0x10000, buffer_grow, 1);
                }
            }
            buffer_delete(map_buffer);
            
            for (var i = 0; i < array_length(Game.meta.export.files); i++) {
                var file_data = Game.meta.export.files[i];
                var this_files_name = save_directory + file_data.name + EXPORT_EXTENSION_ASSETS;
                var buffer = buffer_create(1024, buffer_grow, 1);
                write_header(buffer);
                
                // the default file should have the global settings
                // (including a list of all of the other files)
                if (i == 0) {
                    project_export_global(buffer);
                    this_files_name = fn;
                }
                
                // generate a list of all of the things that are in this file
                for (var j = 0; j < array_length(Game.meta.export.locations); j++) {
                    // the files that are sorted
                    if (Game.meta.export.locations[j] == i) {
                        buffer_write(buffer, buffer_u32, j);
                        game_data_save_scripts[j](buffer);
                    }
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
            
            wtf("Export took " + string((get_timer() - t0) / 1000) + " ms");
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