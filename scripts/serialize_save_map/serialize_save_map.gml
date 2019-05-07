/// @description  void serialize_save_map();

var fn=get_save_filename("DDD map files|*"+EXPORT_EXTENSION_MAP, ActiveMap.internal_name+EXPORT_EXTENSION_MAP);
if (string_length(fn)>0){
    if (filename_name(fn)!=ActiveMap.internal_name+EXPORT_EXTENSION_MAP){
        if (!show_question("The file you are trying to save to does not match the map's internal name ("+ActiveMap.internal_name+
            ". The game won't be able to see it. You sure you want to save it with this name?")){
            
            return 0;
        }
    }
    
    Stuff.save_name_map=string_replace(filename_name(fn), EXPORT_EXTENSION_MAP, "");
    serialize_backup(PATH_BACKUP_MAP, Stuff.save_name_map, EXPORT_EXTENSION_MAP, fn);
    game_auto_title();
    
    var buffer=buffer_create(2, buffer_grow, 1);
    
    /*
     * Header
     */
    
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT-1);
    buffer_write(buffer, buffer_u8, SERIALIZE_MAP);
    buffer_write(buffer, buffer_u32, 0);
    
    
    // for each entity, this gets written in first, and the result is used
    // to determine the type of object to create
    //buffer_write(argument0, buffer_u16, argument1.etype);
    
    /*
     * data
     */
    
    // this one should always come first becaues it defines things
    // like size and tileset
    serialize_save_map_contents_meta(buffer);
    
    // these can come in any order although there probably won't be
    // a great deal of them
    serialize_save_map_contents_batch(buffer);
    serialize_save_map_contents_dynamic(buffer);
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    /*
     * that's it!
     */
    
    if (Stuff.setting_compression_level==0){
        buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
        buffer_save_ext(buffer, "auto"+EXPORT_EXTENSION_MAP, 0, buffer_tell(buffer));
    } else {
        var compressed=buffer_deflate(buffer, 0, buffer_tell(buffer), Stuff.setting_compression_level);
        buffer_save_ext(compressed, fn, 0, buffer_tell(compressed));
        buffer_save_ext(compressed, "auto"+EXPORT_EXTENSION_MAP, 0, buffer_tell(buffer));
        buffer_delete(compressed);
    }
    
    buffer_delete(buffer);
    
    Stuff.all_maps[? ActiveMap.internal_name]=true;
}
