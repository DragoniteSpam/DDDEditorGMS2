/// @param filename

var original = buffer_load(argument0);
var erroneous = false;
var header = chr(buffer_read(original, buffer_u8)) + chr(buffer_read(original, buffer_u8)) + chr(buffer_read(original, buffer_u8));

var buffer = buffer_decompress(original);

// if the decompressed buffer is bad, cancel - try catch will make this so much nicer
if (buffer < 0) {
    erroneous = true;
} else {
    buffer_seek(buffer, buffer_seek_start, 0);
    
    /*
     * Header
     */
    
    var header = chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8));
    
    if (header == "DDD") {
        Stuff.save_name_data = string_replace(filename_name(argument0), EXPORT_EXTENSION_DATA, "");
        
        var version = buffer_read(buffer, buffer_u32);
        
        if (version < DataVersions.MAP_CODE_SINGLE) {
            show_error("We stopped supporting versions of the data file before MAP_CODE_SINGLE (" + string(DataVersions.MAP_CODE_SINGLE) +
                "). This current version is " + string(version) + ". Please open and save " + filename_name(datafile) +
                " through Version 0.1.0.9 of the editor.", true);
        }
        
        var what = buffer_read(buffer, buffer_u8);
        var things = buffer_read(buffer, buffer_u32);
        
        switch (what) {
            case SERIALIZE_ASSETS:
                while (!ds_list_empty(Stuff.all_bgm)) {
                    audio_remove_bgm(ds_list_top(Stuff.all_bgm));
                }
                while (!ds_list_empty(Stuff.all_se)) {
                    audio_remove_bgm(ds_list_top(Stuff.all_se));
                }
                break;
            case SERIALIZE_DATA:
                // this may cause things to break, but it shouldn't;
                // includes data, events, generics and everything else
                instance_activate_object(Data);
                with (Data) if (deleteable) {
                    instance_destroy();
                }
                // clear all data - data has already been destroyed so you just have to
                // clear them
                ds_list_clear(Stuff.all_events);
                ds_list_clear(Stuff.all_event_custom);
                ds_list_clear(Stuff.all_event_templates);
                ds_map_clear(Stuff.all_guids);
                ds_map_clear(Stuff.all_internal_names);
                ds_list_clear(Stuff.all_data);
                break;
            case SERIALIZE_MAP:
                // todo clear editor map - IF entities get their own GUIDs eventually,
                // they should go in a separate lookup which should be cleared in here
                break;
        }
        
        /*
         * data types
         */
        
        // you will never have this many Things
        things = 100000000;
        
        var stop = false;
        repeat(things) {
            var datatype = buffer_read(buffer, buffer_datatype);
            switch (datatype) {
                // game stuff
                case SerializeThings.AUTOTILES:
                    serialize_load_autotiles(buffer, version);
                    break;
                case SerializeThings.TILESET:
                    serialize_load_tilesets(buffer, version);
                    break;
                case SerializeThings.AUDIO_BGM:
                    serialize_load_audio_bgm(buffer, version);
                    break;
                case SerializeThings.AUDIO_SE:
                    serialize_load_audio_se(buffer, version);
                    break;
                case SerializeThings.EVENTS:
                    serialize_load_events(buffer, version);
                    break;
                case SerializeThings.MISC_MAP_META:
                    serialize_load_global_meta(buffer, version);
                    break;
                case SerializeThings.DATADATA:
                    serialize_load_datadata(buffer, version);
                    break;
                case SerializeThings.DATA_INSTANCES:
                    serialize_load_data_instances(buffer, version);
                    break;
                case SerializeThings.EVENT_CUSTOM:
                    serialize_load_event_custom(buffer, version);
                    break;
                // map stuff
                case SerializeThings.MAP_META:
                    serialize_load_map_contents_meta(buffer, version); 
                    break;
                case SerializeThings.MAP_BATCH:
                    serialize_load_map_contents_batch(buffer, version);
                    break;
                case SerializeThings.MAP_DYNAMIC:
                    serialize_load_map_contents_dynamic(buffer, version);
                    break;
                // end of file
                case SerializeThings.END_OF_FILE:
                    stop = true;
                    break;
            }
            
            if (stop) {
                break;
            }
        }
        
        switch (what) {
            case SERIALIZE_MAP:
                Stuff.all_maps[? ActiveMap.internal_name] = true;
                uivc_select_autotile_refresh();
                break;
        }
        
        with (Data) if (deactivateable) {
            instance_deactivate_object(id);
        }
        
        error_show();
        
        game_auto_title();
    } else {
        erroneous = true;
    }
}

if (erroneous) {
    dialog_create_notice(null, "this is a ddd* file but the contents are no good?");
}

/*
 * that's it!
 */

buffer_delete(buffer);
buffer_delete(original);