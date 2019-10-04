var fn = get_save_filename("DDD game data files|*" + EXPORT_EXTENSION_DATA, "game");

if (string_length(fn) > 0) {
    Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
    serialize_backup(PATH_BACKUP_DATA, Stuff.save_name, EXPORT_EXTENSION_DATA, fn);
    game_auto_title();
    
    var buffer = buffer_create(2, buffer_grow, 1);
    
    /*
     * Header
     */
    
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, SERIALIZE_DATA_AND_MAP);
    buffer_write(buffer, buffer_u32, 0);
	
    /*
     * data
     */
    
    serialize_save_event_custom(buffer);
    serialize_save_global_meta(buffer);
    serialize_save_datadata(buffer);
    serialize_save_animations(buffer);
    
    // events may depend on some other data being initialized and i don't feel like
    // going back and doing validation because that sounds terrible
	serialize_save_event_prefabs(buffer);
    serialize_save_events(buffer);
    serialize_save_data_instances(buffer);
	
	serialize_save_maps(buffer);
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    /*
     * that's it!
     */
    
    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
    buffer_save(compressed, fn);
    
    buffer_save(compressed, "auto" + EXPORT_EXTENSION_DATA);
    buffer_delete(compressed);
    buffer_delete(buffer);
	
	serialize_save_assets(filename_change_ext(fn, EXPORT_EXTENSION_ASSETS));
}

enum DataVersions {
    SUMMARY_GENERIC_DATA        = 38,
    MAPS_NUKED                  = 39,
	DATA_TRIMMED				= 40,
	STARTING_POSITION			= 41,
	EVENT_PREFABS				= 42,
	STARTING_DIRECTION			= 43,
	TMX_ID						= 44,
	TS_ID						= 45,
	MAP_VERSIONING				= 46,
	CUSTOM_EVENT_TRIGGERS		= 47,
	CUSTOM_EVENT_OUTBOUND		= 48,
	CODE_OPTIONS				= 49,
    _CURRENT                 /* = whatever the last one is + 1 */
}