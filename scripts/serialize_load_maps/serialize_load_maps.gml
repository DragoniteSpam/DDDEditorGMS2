function serialize_load_maps(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    var n_maps = buffer_read(buffer, buffer_u16);
    
    repeat (n_maps) {
        var map = instance_create_depth(0, 0, 0, DataMapContainer);
        serialize_load_generic(buffer, map, version);
        
        map.version = buffer_read(buffer, buffer_u32);
        
        if (version < LAST_SAFE_VERSION) {
            emu_dialog_notice(
                "We stopped supporting versions of the data file before " + string(LAST_SAFE_VERSION) +
                ". This current version is " + string(version) + ".\nPlease find a version of " + map.name +
                " saved with the last compatible version of the editor. Can't open this one.",
            );
            buffer_delete(buffer);
            return;
        }
        
        if (version >= DataVersions._CURRENT) {
            emu_dialog_notice(
                "The file(s) appear to be from a future version of the data format (" + string(version) +
                "). The latest version supported by this program is " + string(DataVersions._CURRENT) + ".\n" +
                "Please find a version of " + map.name + " saved with the an older version of the editor "+
                " (or update). Can't open."
            );
            buffer_delete(buffer);
            return;
        }
        
        var size = buffer_read(buffer, buffer_u32);
        buffer_delete(map.data_buffer);
        map.data_buffer = buffer_read_buffer(buffer, size);
        
        if (buffer_md5(map.data_buffer, 0, buffer_get_size(map.data_buffer)) != EMPTY_BUFFER_MD5) {
            buffer_seek(map.data_buffer, buffer_seek_start, 0);
            
            buffer_read(map.data_buffer, buffer_u32);
            var skip_addr = buffer_read(map.data_buffer, buffer_u64);
            
            // signed because it's allowed to be -1
            // for those curious, this caused the editor to crash but not the game
            // because the game doesn't read this data here
            map.tiled_map_id = buffer_read(map.data_buffer, buffer_s32);
            map.xx = buffer_read(map.data_buffer, buffer_u16);
            map.yy = buffer_read(map.data_buffer, buffer_u16);
            map.zz = buffer_read(map.data_buffer, buffer_u16);
            
            buffer_seek(map.data_buffer, buffer_seek_start, 0);
        } // else the map has not been initialized yet and it just uses its default values
    }
}