var fn = get_save_filename_dddd(Stuff.save_name);

global.error_map = ds_map_create();

if (string_length(fn) > 0) {
    var save_directory = filename_path(fn);
    var buffers = array_create(ds_list_size(Stuff.game_asset_lists));
    
    Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
    var proj_name = filename_change_ext(filename_name(fn), "");
    setting_project_add(proj_name);
    
    game_auto_title();
    
    var contents = ds_list_create();
    var content_addresses = ds_list_create();
    
    for (var i = 0; i < ds_list_size(Stuff.game_asset_lists); i++) {
        var file_data = Stuff.game_asset_lists[| i];
        var buffer = buffer_create(1024, buffer_grow, 1);
        serialize_save_header(buffer, file_data, (i == 0));
        var index_addr_content = buffer_tell(buffer);
        buffer_write(buffer, buffer_u64, 0);
        
        // the default file should have a list of all of the other files
        if (i == 0) {
            buffer_write(buffer, buffer_u8, ds_list_size(Stuff.game_asset_lists));
            for (var j = 0; j < ds_list_size(Stuff.game_asset_lists); j++) {
                buffer_write(buffer, buffer_string, Stuff.game_asset_lists[| j].internal_name);
                buffer_write(buffer, buffer_u32, Stuff.game_asset_lists[| j].GUID);
            }
        }
        
        // generate a list of all of the things that are in this file
        ds_list_clear(contents);
        ds_list_clear(content_addresses);
        for (var j = 0; j < array_length_1d(Stuff.game_data_location); j++) {
            if (Stuff.game_data_location[j] == file_data.GUID) {
                ds_list_add(contents, j);
            }
            // any data categories that aren't sorted into files go to the default
            if (i == 0 && !guid_get(Stuff.game_data_location[j])) {
                ds_list_add(contents, j);
            }
        }
        
        // write out the addresses of all the things (or at least, allocate space)
        var addr_content = buffer_tell(buffers[i]);
        
        buffer_write(buffer, buffer_u64, 0);
        buffer_write(buffer, buffer_u8, ds_list_size(contents));
        for (var j = 0; j < ds_list_size(contents); j++) {
            ds_list_add(content_addresses, buffer_tell(buffer));
        }
        
        buffer_poke(buffer, addr_content, buffer_u64, buffer_tell(buffer));
        
        // okay now you can *actually* write out the addresses of all the things
        
        for (var j = 0; j < ds_list_size(contents); j++) {
            var addr = script_execute(Stuff.game_data_save_scripts[contents[| j]], buffer);
            buffer_poke(buffer, content_addresses[| j], buffer_u64, addr);
        }
        
        buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
        
        var this_files_name = (i == 0) ? fn : (save_directory + file_data.internal_name + EXPORT_EXTENSION_ASSETS);
        
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
    ds_list_destroy(content_addresses);
}

if (!ds_map_empty(global.error_map)) {
    var error_list = ds_map_to_list_sorted(global.error_map);
    var err_str = "";
    for (var i = 0; i < ds_list_size(error_list); i++) {
        err_str = err_str + "    - " + global.error_map[? error_list[| i]] + "\n";
    }
    var dialog = dialog_create_notice(noone, "Some warnings were generated when saving your data file:\n\n" + err_str, "Warning!", undefined, undefined, 560);
    dialog.el_text.x = 32;
    dialog.el_text.y = 64;
    dialog.el_text.alignment = fa_left;
    dialog.el_text.valignment = fa_top;
    ds_list_destroy(error_list);
}

ds_map_destroy(global.error_map);

enum DataVersions {
    MAP_TILED_ID                = 64,
    GAME_NOTES                  = 65,
    FMOD_SAMPLE_RATE            = 66,
    FMOD_LOOP_POINT_SAMPLES     = 67,
    COLLISION_FLAGS             = 68,
    COLLISION_TRIGGER_DATA      = 69,
    REMOVE_RMXP_DATA            = 70,
    MAP_GENERIC_DATA            = 71,
    DATA_MODULARITY             = 72,
    _CURRENT /* = whatever the last one is + 1 */
}