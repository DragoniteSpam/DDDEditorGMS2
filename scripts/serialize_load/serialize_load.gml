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
        emu_dialog_notice(
            "We stopped supporting versions of the data file before " + string(LAST_SAFE_VERSION) +
            ". This current version is " + string(version) + ".\nPlease find a version of " + filename_name(filename) +
            " saved with the last compatible version of the editor. Can't open this one.",
        );
        buffer_delete(buffer);
        return;
    }
    
    if (version >= DataVersions._CURRENT) {
            emu_dialog_notice(
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
            Game.meta.project.summary = summary_string;
            Game.meta.project.author = author_string;
            
            instance_activate_object(Data);
            with (Data) instance_destroy();
            
            // these contain arrays, which are garbage collected and need to be there
            Game.vars.constants = [];
            Game.vars.variables = [];
            Game.vars.switches = [];
            // reset the active map
            Stuff.map.active_map = noone;
            // these are garbage collected
            Game.meta.export.files = [];
            var n_files = buffer_read(buffer, buffer_u8);
            
            repeat (n_files) {
                var name = buffer_read(buffer, buffer_string);
                var bools = buffer_read(buffer, buffer_u32);
                // the "compressed" parameter can be set later
                var file_data = new DataFile(name, false, unpack(bools, 0));
                array_push(Game.meta.export.files, file_data);
            }
            
            // erase the default game data locations and replace them with
            // whatever file bundle this project uses
            array_clear(Game.meta.export.locations, undefined);
            
            Stuff.game_data_current_file = Game.meta.export.files[0];
            
            break;
        case SERIALIZE_ASSETS:
        default:
            break;
    }
    
    while (true) {
        var datatype = buffer_read(buffer, buffer_u32);
        if (datatype == SerializeThings.END_OF_FILE) break;
        
        switch (datatype) {
            #region big ol' switch statement
            // assets
            case SerializeThings.IMAGE_TILE_ANIMATION:
                Game.meta.export.locations[GameDataCategories.TILE_ANIMATIONS] = Stuff.game_data_current_file;
                serialize_load_image_tile_animations(buffer, version);
                break;
            case SerializeThings.IMAGE_TILESET:
                Game.meta.export.locations[GameDataCategories.TILESETS] = Stuff.game_data_current_file;
                serialize_load_image_tilesets(buffer, version);
                break;
            case SerializeThings.IMAGE_BATTLERS:
                Game.meta.export.locations[GameDataCategories.BATTLERS] = Stuff.game_data_current_file;
                serialize_load_image_battlers(buffer, version);
                break;
            case SerializeThings.IMAGE_OVERWORLD:
                Game.meta.export.locations[GameDataCategories.OVERWORLDS] = Stuff.game_data_current_file;
                serialize_load_image_overworlds(buffer, version);
                break;
            case SerializeThings.IMAGE_PARTICLES:
                Game.meta.export.locations[GameDataCategories.PARTICLES] = Stuff.game_data_current_file;
                serialize_load_image_particles(buffer, version);
                break;
            case SerializeThings.IMAGE_UI:
                Game.meta.export.locations[GameDataCategories.UI] = Stuff.game_data_current_file;
                serialize_load_image_ui(buffer, version);
                break;
            case SerializeThings.IMAGE_SKYBOX:
                Game.meta.export.locations[GameDataCategories.SKYBOX] = Stuff.game_data_current_file;
                serialize_load_image_skybox(buffer, version);
                break;
            case SerializeThings.IMAGE_MISC:
                Game.meta.export.locations[GameDataCategories.MISC] = Stuff.game_data_current_file;
                serialize_load_image_etc(buffer, version);
                break;
            case SerializeThings.AUDIO_BGM:
                Game.meta.export.locations[GameDataCategories.BGM] = Stuff.game_data_current_file;
                serialize_load_audio_bgm(buffer, version);
                break;
            case SerializeThings.AUDIO_SE:
                Game.meta.export.locations[GameDataCategories.SE] = Stuff.game_data_current_file;
                serialize_load_audio_se(buffer, version);
                break;
            case SerializeThings.MESHES:
                Game.meta.export.locations[GameDataCategories.MESH] = Stuff.game_data_current_file;
                serialize_load_meshes(buffer, version);
                break;
            case SerializeThings.MESH_AUTOTILES:
                Game.meta.export.locations[GameDataCategories.MESH_AUTOTILES] = Stuff.game_data_current_file;
                serialize_load_mesh_autotiles(buffer, version);
                break;
            // game stuff
            case SerializeThings.EVENTS:
                Game.meta.export.locations[GameDataCategories.EVENTS] = Stuff.game_data_current_file;
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
                Game.meta.export.locations[GameDataCategories.GLOBAL] = Stuff.game_data_current_file;
                serialize_load_global_meta(buffer, version);
                break;
            case SerializeThings.DATADATA:
                Game.meta.export.locations[GameDataCategories.DATADATA] = Stuff.game_data_current_file;
                serialize_load_datadata(buffer, version);
                break;
            case SerializeThings.DATA_INSTANCES:
                Game.meta.export.locations[GameDataCategories.DATA_INST] = Stuff.game_data_current_file;
                serialize_load_data_instances(buffer, version);
                break;
            case SerializeThings.ANIMATIONS:
                Game.meta.export.locations[GameDataCategories.ANIMATIONS] = Stuff.game_data_current_file;
                serialize_load_animations(buffer, version);
                break;
            case SerializeThings.TERRAIN:
                Game.meta.export.locations[GameDataCategories.TERRAIN] = Stuff.game_data_current_file;
                serialize_load_terrain(buffer, version);
                break;
            case SerializeThings.MAPS:
                Game.meta.export.locations[GameDataCategories.MAP] = Stuff.game_data_current_file;
                serialize_load_maps(buffer, version);
                break;
            case SerializeThings.LANGUAGE_TEXT:
                Game.meta.export.locations[GameDataCategories.LANGUAGE_TEXT] = Stuff.game_data_current_file;
                serialize_load_language(buffer, version);
                break;
            #endregion
        }
    }
    
    switch (what) {
        case SERIALIZE_DATA_AND_MAP:
            for (var i = 1; i < array_length(Game.meta.export.files); i++) {
                Stuff.game_data_current_file = Game.meta.export.files[i];
                var next_file_name = proj_path + Stuff.game_data_current_file.name + EXPORT_EXTENSION_ASSETS;
                if (file_exists(next_file_name)) {
                    var buffer_next = buffer_load(next_file_name);
                    serialize_load(buffer_next, next_file_name, proj_name);
                }
            }
            
            load_a_map(guid_get(Game.meta.start.map));
            break;
    }
    
    buffer_delete(buffer);
}