var fn = get_save_filename("DDD game data files|*" + EXPORT_EXTENSION_DATA, Stuff.save_name);

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
    
	var auto_folder = PATH_PROJECTS + filename_change_ext(filename_name(fn), "") + "\\";
	if (!directory_exists(auto_folder)) {
		directory_create(auto_folder);
	}
    buffer_save(compressed, auto_folder + "auto" + EXPORT_EXTENSION_DATA);
    buffer_delete(compressed);
    buffer_delete(buffer);
	
	serialize_save_assets(filename_change_ext(fn, EXPORT_EXTENSION_ASSETS));
	
	var project_name = filename_change_ext(filename_name(fn), "")
	if (ds_list_find_index(Stuff.all_projects[? "projects"], project_name) == -1) {
		ds_list_add(Stuff.all_projects[? "projects"], project_name);
	}
	
	var buffer = buffer_create(32, buffer_grow, 1);
	buffer_write(buffer, buffer_text, json_encode(Stuff.all_projects));
	buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
	buffer_delete(buffer);
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
    MAP_BATCH_DATA              = 50,
    _CURRENT                 /* = whatever the last one is + 1 */
}