function serialize_load(buffer, filename, proj_name) {
    var proj_path = filename_path(filename);
    var erroneous = false;
    
    setting_project_create_local(proj_name, filename_name(filename), buffer);
    
    var header_zlib_data = buffer_peek(buffer, 0, buffer_u16);
    if (header_zlib_data == MAGIC_ZLIB_HEADER) {
        var decompressed = buffer_decompress(buffer);
        buffer_delete(buffer);
        buffer = decompressed;
        Stuff.game_data_current_file.compressed = true;
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    // get on with the header
    buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_u8);
    buffer_read(buffer, buffer_u8);
    
    var version = buffer_read(buffer, buffer_u32);
    
    if (version < LAST_SAFE_VERSION) {
        dialog_create_notice(noone,
            "We stopped supporting versions of the data file before " + string(LAST_SAFE_VERSION) +
            ". This current version is " + string(version) + ".\nPlease find a version of " + filename_name(filename) +
            " saved with the last compatible version of the editor. Can't open this one.",
        );
        buffer_delete(buffer);
        return;
    }
    
    if (version >= DataVersions._CURRENT) {
            dialog_create_notice(noone,
                "The file(s) appear to be from a future version of the data format (" + string(version) +
                "). The latest version supported by this program is " + string(DataVersions._CURRENT) + ".\n" +
                "Please find a version of " + filename + " saved with the an older version of the editor "+
                " (or update). Can't open."
            );
        buffer_delete(buffer);
        return;
    }
    
    var what = buffer_read(buffer, buffer_u8);
    
    switch (what) {
        case SERIALIZE_DATA_AND_MAP:
            var summary_string = buffer_read(buffer, buffer_string);
            var author_string = buffer_read(buffer, buffer_string);
            var file_year = buffer_read(buffer, buffer_u16);
            var file_month = buffer_read(buffer, buffer_u8);
            var file_day = buffer_read(buffer, buffer_u8);
            var file_hour = buffer_read(buffer, buffer_u8);
            var file_minute = buffer_read(buffer, buffer_u8);
            var file_second = buffer_read(buffer, buffer_u8);
            
            instance_activate_object(Data);
            with (Data) instance_destroy();
            // i seriously have no idea why this isn't being included in the above with() so
            // let's try deleting them manually
            with (DataDataFile) instance_destroy();
            
            // i'd like there to be a default event, although potentially in the future there will not be
            ds_list_clear(Stuff.all_events);
            // these contain arrays, which are garbage collected and need to be there
            ds_list_clear(Stuff.all_game_constants);
            ds_list_clear(Stuff.variables);
            ds_list_clear(Stuff.switches);
            // reset the active map
            Stuff.map.active_map = noone;
            // data file list
            ds_list_clear(Stuff.game_asset_lists);
            var n_files = buffer_read(buffer, buffer_u8);
            
            repeat (n_files) {
                var name = buffer_read(buffer, buffer_string);
                var guid = buffer_read(buffer, buffer_get_datatype(version));
                var bools = buffer_read(buffer, buffer_u32);
                
                // the "compressed" parameter can be set later
                var file_data = create_data_file(name, false);
                guid_set(file_data, guid);
                ds_list_add(Stuff.game_asset_lists, file_data);
                
                file_data.critical = unpack(bools, 0);
            }
            
            Stuff.game_data_current_file = Stuff.game_asset_lists[| 0];
            
            Stuff.game_file_summary = summary_string;
            Stuff.game_file_author = author_string;
            break;
        case SERIALIZE_ASSETS:
        default:
            break;
    }
    
    while (true) {
        var datatype = buffer_read(buffer, buffer_u32);
        if (datatype == SerializeThings.END_OF_FILE) {
            break;
        }
        
        switch (datatype) {
            #region big ol' switch statement
            // assets
            case SerializeThings.IMAGE_TILE_ANIMATION:
                Stuff.game_data_location[GameDataCategories.TILE_ANIMATIONS] = Stuff.game_data_current_file.GUID;
                serialize_load_image_tile_animations(buffer, version);
                break;
            case SerializeThings.IMAGE_TILESET:
                Stuff.game_data_location[GameDataCategories.TILESETS] = Stuff.game_data_current_file.GUID;
                serialize_load_image_tilesets(buffer, version);
                break;
            case SerializeThings.IMAGE_BATTLERS:
                Stuff.game_data_location[GameDataCategories.BATTLERS] = Stuff.game_data_current_file.GUID;
                serialize_load_image_battlers(buffer, version);
                break;
            case SerializeThings.IMAGE_OVERWORLD:
                Stuff.game_data_location[GameDataCategories.OVERWORLDS] = Stuff.game_data_current_file.GUID;
                serialize_load_image_overworlds(buffer, version);
                break;
            case SerializeThings.IMAGE_PARTICLES:
                Stuff.game_data_location[GameDataCategories.PARTICLES] = Stuff.game_data_current_file.GUID;
                serialize_load_image_particles(buffer, version);
                break;
            case SerializeThings.IMAGE_UI:
                Stuff.game_data_location[GameDataCategories.UI] = Stuff.game_data_current_file.GUID;
                serialize_load_image_ui(buffer, version);
                break;
            case SerializeThings.IMAGE_SKYBOX:
                Stuff.game_data_location[GameDataCategories.SKYBOX] = Stuff.game_data_current_file.GUID;
                serialize_load_image_skybox(buffer, version);
                break;
            case SerializeThings.IMAGE_MISC:
                Stuff.game_data_location[GameDataCategories.MISC] = Stuff.game_data_current_file.GUID;
                serialize_load_image_etc(buffer, version);
                break;
            case SerializeThings.AUDIO_BGM:
                Stuff.game_data_location[GameDataCategories.BGM] = Stuff.game_data_current_file.GUID;
                serialize_load_audio_bgm(buffer, version);
                break;
            case SerializeThings.AUDIO_SE:
                Stuff.game_data_location[GameDataCategories.SE] = Stuff.game_data_current_file.GUID;
                serialize_load_audio_se(buffer, version);
                break;
            case SerializeThings.MESHES:
                Stuff.game_data_location[GameDataCategories.MESH] = Stuff.game_data_current_file.GUID;
                serialize_load_meshes(buffer, version);
                break;
            case SerializeThings.MESH_AUTOTILES:
                Stuff.game_data_location[GameDataCategories.MESH_AUTOTILES] = Stuff.game_data_current_file.GUID;
                
                break;
            // game stuff
            case SerializeThings.EVENTS:
                Stuff.game_data_location[GameDataCategories.EVENTS] = Stuff.game_data_current_file.GUID;
                serialize_load_events(buffer, version);
                break;
            case SerializeThings.EVENT_CUSTOM:
                // these are part of events
                serialize_load_event_custom(buffer, version);
                break;
            case SerializeThings.EVENT_PREFAB:
                // these are part of events
                serialize_load_event_prefabs(buffer, version);
                break;
            case SerializeThings.GLOBAL_METADATA:
                Stuff.game_data_location[GameDataCategories.GLOBAL] = Stuff.game_data_current_file.GUID;
                serialize_load_global_meta(buffer, version);
                break;
            case SerializeThings.DATADATA:
                Stuff.game_data_location[GameDataCategories.DATADATA] = Stuff.game_data_current_file.GUID;
                serialize_load_datadata(buffer, version);
                break;
            case SerializeThings.DATA_INSTANCES:
                Stuff.game_data_location[GameDataCategories.DATA_INST] = Stuff.game_data_current_file.GUID;
                serialize_load_data_instances(buffer, version);
                break;
            case SerializeThings.ANIMATIONS:
                Stuff.game_data_location[GameDataCategories.ANIMATIONS] = Stuff.game_data_current_file.GUID;
                serialize_load_animations(buffer, version);
                break;
            case SerializeThings.TERRAIN:
                Stuff.game_data_location[GameDataCategories.TERRAIN] = Stuff.game_data_current_file.GUID;
                serialize_load_terrain(buffer, version);
                break;
            case SerializeThings.MAPS:
                Stuff.game_data_location[GameDataCategories.MAP] = Stuff.game_data_current_file.GUID;
                serialize_load_maps(buffer, version);
                break;
            case SerializeThings.LANGUAGE_TEXT:
                Stuff.game_data_location[GameDataCategories.LANGUAGE_TEXT] = Stuff.game_data_current_file.GUID;
                serialize_load_language(buffer, version);
                break;
            #endregion
        }
    }
    
    switch (what) {
        case SERIALIZE_DATA_AND_MAP:
            for (var i = 1; i < ds_list_size(Stuff.game_asset_lists); i++) {
                Stuff.game_data_current_file = Stuff.game_asset_lists[| i];
                var next_file_name = proj_path + Stuff.game_data_current_file.internal_name + EXPORT_EXTENSION_ASSETS;
                if (file_exists(next_file_name)) {
                    var buffer_next = buffer_load(next_file_name);
                    serialize_load(buffer_next, next_file_name, proj_name);
                }
            }
            
            load_a_map(guid_get(Stuff.game_starting_map));
            break;
    }
    
    buffer_delete(buffer);
}