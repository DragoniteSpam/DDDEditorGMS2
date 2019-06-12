var fn = get_save_filename("DDD game data files|*" + EXPORT_EXTENSION_DATA, "game");
if (string_length(fn) > 0) {
    Stuff.save_name_data=string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
    serialize_backup(PATH_BACKUP_DATA, Stuff.save_name_data, EXPORT_EXTENSION_DATA, fn);
    game_auto_title();
    
    var buffer = buffer_create(2, buffer_grow, 1);
    
    /*
     * Header
     */
    
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT-1);
    buffer_write(buffer, buffer_u8, SERIALIZE_DATA);
    buffer_write(buffer, buffer_u32, 0);
    
    /*
     * data
     */
    
    //serialize_save_autotiles_meta(buffer);
    serialize_save_autotiles_all(buffer);
    //serialize_save_tilesets_meta(buffer);
    serialize_save_tilesets_all(buffer);
    serialize_save_event_custom(buffer);
    serialize_save_global_meta(buffer);
    serialize_save_datadata(buffer);
    
    // events may depend on some other data being initialized and i don't feel like
    // going back and doing validation because that sounds terrible
    serialize_save_events(buffer);
    
    serialize_save_data_instances(buffer);
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    /*
     * that's it!
     */
    
    if (Stuff.setting_compress) {
		var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
        buffer_save(compressed, fn);
        buffer_save(compressed, "auto" + EXPORT_EXTENSION_DATA);
        buffer_delete(compressed);
    } else {
        buffer_save_ext(buffer, fn, 0, buffer_tell(buffer));
        buffer_save_ext(buffer, "auto" + EXPORT_EXTENSION_DATA, 0, buffer_tell(buffer));
    }
    
    buffer_delete(buffer);
}

enum DataVersions {
    INITIAL                     = 0,
    VRAX_REFERENCE              = 1,
    STARTING_MAP                = 2,
    MAP_VARS                    = 3,
    MAP_3D                      = 4,
    GAMEPLAY_GRID               = 5,
    EVENT_GUID                  = 6,
    MAP_ENTITY_EVENTS           = 7,
    EVENT_NODE_GUID             = 8,
    EVENT_NODE_FIXED_DATA_AGAIN = 9,
    ENTITY_TRANSFORM            = 10,
    DATADATA_DEFINITIONS        = 11,
    NOT_STUPID_DATA_SIZE        = 12,
    OPTIONS_ON_ENTITIES         = 13,
    OPTIONS_ON_ENTITIES_WORKS   = 14,
    MOVE_ROUTES                 = 15,
    ENTITY_GUID                 = 16,
    MOVE_ROUTE_MOVE_PARAMS      = 17,
	__UNUSED_00			        = 18, // not used, i don't think, but i can't remove it now
    ENTITY_MAP_OPTIONS_WHOOPS   = 19,
    VARIABLE_BATTLE             = 20,
    MAP_WEATHER_CODE            = 21,
    _CURRENT                    /* = whatever the last one is + 1 */
}
