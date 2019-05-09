/// @description  void serialize_load(filename);
/// @param filename

var original=buffer_load(argument0);
var erroneous=false;
var header=chr(buffer_read(original, buffer_u8))+chr(buffer_read(original, buffer_u8))+chr(buffer_read(original, buffer_u8));

if (header=="DDD"){
    // if it's uncompressed, don't decompress it
    var buffer=original;
} else {
    // if it's compressed, decompress it - if possible
    var buffer=buffer_decompress(original);
    buffer_delete(original);
}

// if the decompressed buffer is bad, cancel - try catch will make this so much nicer
if (buffer < 0){
    erroneous=true;
} else {
    buffer_seek(buffer, buffer_seek_start, 0);
    
    /*
     * Header
     */
    
    var header=chr(buffer_read(buffer, buffer_u8))+chr(buffer_read(buffer, buffer_u8))+chr(buffer_read(buffer, buffer_u8));
    
    if (header=="DDD"){
        Stuff.save_name_data=string_replace(filename_name(argument0), EXPORT_EXTENSION_DATA, "");
        
        var version=buffer_read(buffer, buffer_u32);
        var what=buffer_read(buffer, buffer_u8);
        var things=buffer_read(buffer, buffer_u32);
        
        if (what==SERIALIZE_DATA){
            // this may cause things to break, but it shouldn't;
            // includes data, events, generics and everything else
            instance_activate_object(Data);
            with (Data) if (deleteable){
                instance_destroy();
            }
            // clear all data - data has already been destroyed so you just have to
            // clear them
            ds_list_clear(Stuff.all_events);
            ds_list_clear(Stuff.all_event_custom);
            ds_list_clear(Stuff.all_event_templates);
            ds_map_clear(Stuff.all_guids);
            ds_list_clear(Stuff.all_data);
        } else if (what==SERIALIZE_MAP){
            // todo clear editor map - IF entities get their own GUIDs eventually,
            // they should go in a separate lookup which should be cleared in here
        }
        
        /*
         * data types
         */
        
        if (version>=DataVersions.NOT_STUPID_DATA_SIZE){
            // you will never have this many Things
            things=100000000;
        }
        
        var stop=false;
        repeat(things){
            var datatype=buffer_read(buffer, buffer_datatype);
            switch (datatype){
                // game stuff
                case SerializeThings.AUTOTILES_META:
                    serialize_load_autotiles_meta(buffer, version);
                    break;
                case SerializeThings.TILESET_META:
                    serialize_load_tilesets_meta(buffer, version);
                    break;
                case SerializeThings.TILESET_ALL:
                    serialize_load_tilesets_all(buffer, version);
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
                    stop=true;
                    break;
            }
            
            if (stop){
                break;
            }
        }
        
        if (what==SERIALIZE_MAP){
            Stuff.all_maps[? ActiveMap.internal_name]=true;
            uivc_select_autotile_refresh(/*Camera.selection_fill_autotile*/);
        }
        
        with (Data) if (deactivateable){
            instance_deactivate_object(id);
        }
        
        error_show();
        
        game_auto_title();
    } else {
        erroneous=true;
    }
}

if (erroneous){
    dialog_create_notice(null, "this is a ddd* file but the contents are no good?");
}

/*
 * that's it!
 */

buffer_delete(buffer);
