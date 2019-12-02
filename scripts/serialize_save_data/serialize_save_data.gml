var fn = get_save_filename_dddd(Stuff.save_name);

global.error_map = ds_map_create();

if (string_length(fn) > 0) {
    Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
    serialize_backup(PATH_BACKUP, Stuff.save_name, EXPORT_EXTENSION_DATA, fn);
    game_auto_title();
    
    var buffer = buffer_create(1024, buffer_grow, 1);
    
    #region header and index
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u8, $44);
    buffer_write(buffer, buffer_u32, DataVersions._CURRENT - 1);
    buffer_write(buffer, buffer_u8, SERIALIZE_DATA_AND_MAP);
    
    // lol
    var index_addr_content = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var index_addr_event_custom = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_global_meta = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_datadata = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_animations = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_terrain = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var index_addr_event_prefabs = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_events = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var index_addr_data_instances = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var index_addr_maps = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    #endregion
    
    buffer_poke(buffer, index_addr_content, buffer_u64, buffer_tell(buffer));
    
    #region data
    var addr_event_custom =         serialize_save_event_custom(buffer);
    var addr_global_meta =          serialize_save_global_meta(buffer);
    var addr_datadata =             serialize_save_datadata(buffer);
    var addr_animations =           serialize_save_animations(buffer);
    var addr_terrain =              Stuff.game_include_terrain ? serialize_save_terrain(buffer) : 0;
    
    // events may depend on some other data being initialized and i don't feel like
    // going back and doing validation because that sounds terrible
    var addr_event_prefabs =        serialize_save_event_prefabs(buffer);
    var addr_events =               serialize_save_events(buffer);
    var addr_data_instances =       serialize_save_data_instances(buffer);
    
    var addr_maps =                 serialize_save_maps(buffer);
    #endregion
    
    #region addresses
    buffer_poke(buffer, index_addr_event_custom, buffer_u64, addr_event_custom);
    buffer_poke(buffer, index_addr_global_meta, buffer_u64, addr_global_meta);
    buffer_poke(buffer, index_addr_datadata, buffer_u64, addr_datadata);
    buffer_poke(buffer, index_addr_animations, buffer_u64, addr_animations);
    buffer_poke(buffer, index_addr_terrain, buffer_u64, addr_terrain);
    buffer_poke(buffer, index_addr_event_prefabs, buffer_u64, addr_event_prefabs);
    buffer_poke(buffer, index_addr_events, buffer_u64, addr_events);
    buffer_poke(buffer, index_addr_data_instances, buffer_u64, addr_data_instances);
    buffer_poke(buffer, index_addr_maps, buffer_u64, addr_maps);
    #endregion
    
    buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);
    
    var compressed = buffer_compress(buffer, 0, buffer_tell(buffer));
    buffer_save(compressed, fn);
    
    serialize_save_assets(filename_change_ext(fn, EXPORT_EXTENSION_ASSETS));
    
    var proj_name = filename_change_ext(filename_name(fn), "");
    setting_project_add(proj_name);
    setting_project_create_local(proj_name, undefined, compressed);
    
    buffer_delete(compressed);
    buffer_delete(buffer);
}

if (!ds_map_empty(global.error_map)) {
    var error_list = ds_map_to_list_sorted(global.error_map);
    var err_str = "";
    for (var i = 0; i < ds_list_size(error_list); i++) {
        err_str = err_str + "    - " + global.error_map[? error_list[| i]] + "\n";
    }
    var dialog = dialog_create_notice(noone, "Some warnings were generated when saving your data file:\n\n" + err_str, "Warning!", undefined, undefined, 560);
    dialog.el_text.x = 32;
    dialog.el_text.y = 64;
    dialog.el_text.alignment = fa_left;
    dialog.el_text.valignment = fa_top;
    ds_list_destroy(error_list);
}

ds_map_destroy(global.error_map);

enum DataVersions {
    SUMMARY_GENERIC_DATA        = 38,
    MAPS_NUKED                  = 39,
    DATA_TRIMMED                = 40,
    STARTING_POSITION           = 41,
    EVENT_PREFABS               = 42,
    STARTING_DIRECTION          = 43,
    TMX_ID                      = 44,
    TS_ID                       = 45,
    MAP_VERSIONING              = 46,
    CUSTOM_EVENT_TRIGGERS       = 47,
    CUSTOM_EVENT_OUTBOUND       = 48,
    CODE_OPTIONS                = 49,
    MAP_BATCH_DATA              = 50,
    MAP_BATCH_SOLIDNESS_DATA    = 51,
    SMF_MESH_TYPE               = 52,
    SMF_MESH_ANIMATIONS         = 53,
    IMAGE_SPRITE_SIZES          = 54,
    ENUM_SAVED_AS_TYPE          = 55,
    GLOBAL_CONSTANTS            = 56,
    EXTRA_FOG_PROPERTIES        = 57,
    MAP_GRID_PROPERTY           = 58,
    AT_OVERHAUL                 = 59,
    DATA_CHUNK_ADDRESSES        = 60,
    REMOVE_UNUSED_DATA          = 61,
    GENERIC_DATA                = 62,
    PAWN_HELPFUL_DATA           = 63,
    MAP_TILED_ID                = 64,
    _CURRENT /* = whatever the last one is + 1 */
}