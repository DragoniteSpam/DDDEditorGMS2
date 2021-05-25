function serialize_load_base(fn, project_name) {
    var outcome = true;
    
    var fn_data = filename_change_ext(fn, EXPORT_EXTENSION_DATA);
    
    var original_data = -1;
    var decompressed_data = -1;
    
    if (!file_exists(fn_data)) {
        emu_dialog_notice("Could not find a data file (it should be named \"" + filename_name(fn_data) +"\".");
        outcome = false;
    }
    
    // this is a bit ugly, but there are various points where the loading can fail, so after
    // each point it needs to be wrapped in another check because trying to proceed would make
    // the whole thing explode
    if (outcome) {
        var original_data = buffer_load(fn_data);
        
        var header_zlib_data = buffer_peek(original_data, 0, buffer_u16);
        
        if (header_zlib_data == MAGIC_ZLIB_HEADER) {
            var decompressed_data = buffer_decompress(original_data);
            var buffer_data = decompressed_data;
            buffer_delete(original_data);
        } else {
            var buffer_data = original_data;
        }
        
        // header
        var header_data = chr(buffer_read(buffer_data, buffer_u8)) + chr(buffer_read(buffer_data, buffer_u8)) + chr(buffer_read(buffer_data, buffer_u8));
        
        if (header_data != "DDD") {
            emu_dialog_notice("The data file isn't any good (" + fn_data + "). Please load a valid data file.");
            outcome = false;
        }
        
        if (outcome) {
            var version_data = buffer_read(buffer_data, buffer_u32);
            
            if (version_data < LAST_SAFE_VERSION) {
                emu_dialog_notice("We stopped supporting versions of the data file before " + string(LAST_SAFE_VERSION) +
                    ". This file's version is " + string(version_data) + ". Please find a version of " + filename_name(fn_data) +
                    " made with a more up-to-date version of the editor - the last version which nuked compatibility was " +
                    LAST_SAFE_VERSION + ".", true
                );
                outcome = false;
            }
            
            if (outcome) {
                setting_project_add(project_name);
                game_auto_title();
                Stuff.save_name = project_name;
                
                serialize_load(buffer_data, fn_data, project_name);
            }
        }
    }
    
    buffer_delete(original_data);
    
    return outcome;
}