var fn = get_save_filename("DDD game data files|*" + EXPORT_EXTENSION_ASSETS, "assets");
if (string_length(fn) > 0) {
    Stuff.save_name_data=string_replace(filename_name(fn), EXPORT_EXTENSION_ASSETS, "");
    serialize_backup(PATH_BACKUP_DATA, Stuff.save_name_data, EXPORT_EXTENSION_ASSETS, fn);
    game_auto_title();
    
    var buffer = buffer_create(2, buffer_grow, 1);
    
    /*
     * Header
     */
    
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, SERIALIZE_ASSETS);
    buffer_write(buffer, buffer_u32, 0);
    
    /*
     * data
     */
    
    //serialize_save_autotiles_meta(buffer);
    serialize_save_autotiles_all(buffer);
    //serialize_save_tilesets_meta(buffer);
    serialize_save_tilesets_all(buffer);
    serialize_save_bgm(buffer);
    serialize_save_se(buffer);
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    /*
     * that's it!
     */
    
    if (Stuff.setting_compress) {
		var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
        buffer_save(compressed, fn);
        buffer_save(compressed, "auto" + EXPORT_EXTENSION_ASSETS);
        buffer_delete(compressed);
    } else {
        buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
        buffer_save_ext(buffer, "auto" + EXPORT_EXTENSION_ASSETS, 0, buffer_tell(buffer));
    }
    
    buffer_delete(buffer);
}