function serialize_save_data() {
    var fn = get_save_filename_dddd(Stuff.save_name);
    
    global.error_map = { };
    
    if (string_length(fn) > 0) {
        var save_directory = filename_path(fn);
        var buffers = array_create(array_length(Game.export.files));
        
        Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
        var proj_name = filename_change_ext(filename_name(fn), "");
        
        game_auto_title();
        
        var contents = ds_list_create();
        
        for (var i = 0; i < array_length(Game.export.files); i++) {
            var file_data = Game.export.files[i];
            var buffer = buffer_create(1024, buffer_grow, 1);
            serialize_save_header(buffer, file_data, (i == 0));
            
            // the default file should have a list of all of the other files
            if (i == 0) {
                buffer_write(buffer, buffer_u8, array_length(Game.export.files));
                for (var j = 0; j < array_length(Game.export.files); j++) {
                    var asset_file = Game.export.files[j];
                    var bools = pack(asset_file.critical);
                    buffer_write(buffer, buffer_string, asset_file.name);
                    buffer_write(buffer, buffer_u32, bools);
                }
            }
            
            // generate a list of all of the things that are in this file
            ds_list_clear(contents);
            for (var j = 0; j < array_length(Game.export.locations); j++) {
                // the files that are sorted
                if (Game.export.locations[j] == file_data) {
                    ds_list_add(contents, j);
                }
                // any data categories that aren't sorted into files go to the default
                if (i == 0 && !Game.export.locations[j]) {
                    ds_list_add(contents, j);
                }
            }
            
            // okay now you can *actually* write out the addresses of all the things
            // there's no need to save the size here because it reads until the EOF
            for (var j = 0; j < ds_list_size(contents); j++) {
                var addr = Stuff.game_data_save_scripts[contents[| j]](buffer);
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
        
        ds_list_destroy(contents);
    }
    
    if (variable_struct_names_count(global.error_map) > 0) {
        var error_list = variable_struct_get_names(global.error_map);
        array_sort(error_list, false);
        var err_str = "";
        for (var i = 0; i < array_length(error_list); i++) {
            err_str = err_str + "    - " + global.error_map[$ error_list[i]] + "\n";
        }
        var dialog = emu_dialog_notice("Some warnings were generated when saving your data file:\n\n" + err_str, "Warning!", 560);
        dialog.el_text.x = 32;
        dialog.el_text.y = 64;
        dialog.el_text.alignment = fa_left;
        dialog.el_text.valignment = fa_top;
    }
    
    #macro LAST_SAFE_VERSION DataVersions.MESH_TEXTURE_SCALE
    enum DataVersions {
        MESH_TEXTURE_SCALE                  = 125, /* 18 may 2021 */
        NO_EDITOR_DATA                      = 126, /* 29 may 2021 */
        _CURRENT /* = whatever the last one is + 1 */
    }
}