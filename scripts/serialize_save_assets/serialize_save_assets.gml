/// @param filename

var fn = argument0;

if (string_length(fn) > 0) {
    Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_ASSETS, "");
    serialize_backup(PATH_BACKUP_DATA, Stuff.save_name, EXPORT_EXTENSION_ASSETS, fn);
    game_auto_title();
    
    var buffer = buffer_create(65536, buffer_grow, 1);
    
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
    
    serialize_save_autotiles(buffer);
    serialize_save_tilesets(buffer);
    serialize_save_bgm(buffer);
    serialize_save_se(buffer);
    serialize_save_meshes(buffer);
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    /*
     * that's it!
     */
    
    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
    buffer_save(compressed, fn);
    buffer_save(compressed, "auto" + EXPORT_EXTENSION_ASSETS);
    buffer_delete(compressed);
    buffer_delete(buffer);
}