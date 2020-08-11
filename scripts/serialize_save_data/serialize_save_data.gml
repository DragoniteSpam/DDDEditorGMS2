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
    
    for (var i = 0; i < ds_list_size(Stuff.game_asset_lists); i++) {
        var file_data = Stuff.game_asset_lists[| i];
        var buffer = buffer_create(1024, buffer_grow, 1);
        serialize_save_header(buffer, file_data, (i == 0));
        
        // the default file should have a list of all of the other files
        if (i == 0) {
            buffer_write(buffer, buffer_u8, ds_list_size(Stuff.game_asset_lists));
            for (var j = 0; j < ds_list_size(Stuff.game_asset_lists); j++) {
                var asset_file = Stuff.game_asset_lists[| j];
                var bools = pack(asset_file.critical);
                buffer_write(buffer, buffer_string, asset_file.internal_name);
                buffer_write(buffer, buffer_datatype, asset_file.GUID);
                buffer_write(buffer, buffer_u32, bools);
            }
        }
        
        // generate a list of all of the things that are in this file
        ds_list_clear(contents);
        for (var j = 0; j < array_length_1d(Stuff.game_data_location); j++) {
            // the files that are sorted
            if (Stuff.game_data_location[j] == file_data.GUID) {
                ds_list_add(contents, j);
            }
            // any data categories that aren't sorted into files go to the default
            if (i == 0 && !guid_get(Stuff.game_data_location[j])) {
                ds_list_add(contents, j);
            }
        }
        
        // okay now you can *actually* write out the addresses of all the things
        // there's no need to save the size here because it reads until the EOF
        for (var j = 0; j < ds_list_size(contents); j++) {
            var addr = script_execute(Stuff.game_data_save_scripts[contents[| j]], buffer);
        }
        
        buffer_write(buffer, buffer_u32, SerializeThings.END_OF_FILE);
        
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
    NUKE_UNUSED_BOOLS                   = 98,
    BASE_SCREEN_DIMENSIONS              = 99,
    PROPERTY_SIZE_CAN_BE_ZERO           = 100,
    MAP_PLAYER_LIGHT                    = 101,
    ID_OVERHAUL                         = 102,  // sequential IDs, and IDs are strings rather than ints
    ASSET_ID                            = 103,
    ANIMATED_TILES                      = 104,
    EVEN_MORE_MESH_METADATA             = 105,
    MAP_STATIC_BATCHES                  = 106,
    NO_EVENT_PAGE_GUID                  = 107,
    MESH_ANIMATION                      = 108,
    UPDATED_EVENT_NODE_CONNECTIONS      = 109,
    MAP_SKYBOX_DATA                     = 110,
    MAP_ENTITY_CHUNKS                   = 111,
    MESH_MATERIALS                      = 112,
    REMOVE_MESH_TEX_SCALE               = 113,
    MAP_FROZEN_TAGS                     = 114,
    _CURRENT /* = whatever the last one is + 1 */
}