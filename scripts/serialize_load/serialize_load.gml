/// @param buffer
/// @param filename
/// @param proj-name

var buffer = argument0;
var filename = argument1;
var proj_name = argument2;
var proj_path = filename_path(filename);
var erroneous = false;

setting_project_create_local(proj_name, filename_name(filename), buffer);

var header_zlib_data = buffer_peek(buffer, 0, buffer_u16);
if (header_zlib_data == MAGIC_ZLIB_HEADER) {
    var decompressed = buffer_decompress(buffer);
    buffer_delete(buffer);
    buffer = decompressed;
    Stuff.game_data_current_file.compressed = true;
}

buffer_seek(buffer, buffer_seek_start, 0);

// get on with the header
buffer_read(buffer, buffer_u8);
buffer_read(buffer, buffer_u8);
buffer_read(buffer, buffer_u8);

var version = buffer_read(buffer, buffer_u32);

// there is no way i'm including both versions of the load code in one script
if (version >= DataVersions.DATA_MODULARITY) {
} else {
    return serialize_load_old(buffer);
}

if (version >= DataVersions._CURRENT) {
    dialog_create_notice(noone,
        "The file(s) appear to be from a future version of the data format (" + string(version) +
        "). The latest version supported by this program is " + string(DataVersions._CURRENT) + ". Can't open."
    );
    buffer_delete(buffer);
    return false;
}

var what = buffer_read(buffer, buffer_u8);
var summary_string = buffer_read(buffer, buffer_string);
var author_string = buffer_read(buffer, buffer_string);
var file_year = buffer_read(buffer, buffer_u16);
var file_month = buffer_read(buffer, buffer_u8);
var file_day = buffer_read(buffer, buffer_u8);
var file_hour = buffer_read(buffer, buffer_u8);
var file_minute = buffer_read(buffer, buffer_u8);
var file_second = buffer_read(buffer, buffer_u8);

switch (what) {
    case SERIALIZE_DATA_AND_MAP:
        instance_activate_object(Data);
        with (Data) {
            instance_destroy(id);
        }
        // i seriously have no idea why this isn't being included in the above with() so
        // let's try deleting them manually
        with (DataDataFile) {
            instance_destroy();
        }
        // clear all data - data has already been destroyed so you just have to clear them
        ds_list_clear(Stuff.all_events);
        ds_list_clear(Stuff.all_event_custom);
        ds_list_clear(Stuff.all_event_prefabs);
        ds_list_clear(Stuff.all_data);
        ds_list_clear(Stuff.all_game_constants);
        ds_list_clear(Stuff.all_graphic_autotiles);
        ds_list_clear(Stuff.all_graphic_tilesets);
        ds_list_clear(Stuff.all_graphic_overworlds);
        ds_list_clear(Stuff.all_graphic_battlers);
        ds_list_clear(Stuff.all_graphic_particles);
        ds_list_clear(Stuff.all_graphic_ui);
        ds_list_clear(Stuff.all_graphic_etc);
        // these contain arrays, which are garbage collected
        ds_list_clear(Stuff.variables);
        ds_list_clear(Stuff.switches);
        // reset the active map
        Stuff.map.active_map = noone;
        // data file list
        ds_list_clear(Stuff.game_asset_lists);
        var n_files = buffer_read(buffer, buffer_u8);
        
        repeat (n_files) {
            var name = buffer_read(buffer, buffer_string);
            var guid = buffer_read(buffer, buffer_u32);
            // the "compressed" parameter can be set later
            var file_data = create_data_file(name, false);
            guid_set(file_data, guid);
            ds_list_add(Stuff.game_asset_lists, file_data);
        }
        
        Stuff.game_data_current_file = Stuff.game_asset_lists[| 0];
        
        Stuff.game_file_summary = summary_string;
        Stuff.game_file_author = author_string;
        break;
    case SERIALIZE_ASSETS:
        break;
}

while (true) {
    var datatype = buffer_read(buffer, buffer_datatype);
    if (datatype == SerializeThings.END_OF_FILE) {
        break;
    }
    
    switch (datatype) {
        #region big ol' switch statement
        // assets
        case SerializeThings.IMAGE_AUTOTILES:
            Stuff.game_data_location[GameDataCategories.AUTOTILES] = Stuff.game_data_current_file.GUID;
            serialize_load_image_autotiles(buffer, version);
            break;
        case SerializeThings.IMAGE_TILESET:
            Stuff.game_data_location[GameDataCategories.TILESETS] = Stuff.game_data_current_file.GUID;
            serialize_load_image_tilesets(buffer, version);
            break;
        case SerializeThings.IMAGE_BATTLERS:
            Stuff.game_data_location[GameDataCategories.BATTLERS] = Stuff.game_data_current_file.GUID;
            serialize_load_image_battlers(buffer, version);
            break;
        case SerializeThings.IMAGE_OVERWORLD:
            Stuff.game_data_location[GameDataCategories.OVERWORLDS] = Stuff.game_data_current_file.GUID;
            serialize_load_image_overworlds(buffer, version);
            break;
        case SerializeThings.IMAGE_PARTICLES:
            Stuff.game_data_location[GameDataCategories.PARTICLES] = Stuff.game_data_current_file.GUID;
            serialize_load_image_particles(buffer, version);
            break;
        case SerializeThings.IMAGE_UI:
            Stuff.game_data_location[GameDataCategories.UI] = Stuff.game_data_current_file.GUID;
            serialize_load_image_ui(buffer, version);
            break;
        case SerializeThings.IMAGE_MISC:
            Stuff.game_data_location[GameDataCategories.MISC] = Stuff.game_data_current_file.GUID;
            serialize_load_image_etc(buffer, version);
            break;
        case SerializeThings.AUDIO_BGM:
            Stuff.game_data_location[GameDataCategories.BGM] = Stuff.game_data_current_file.GUID;
            serialize_load_audio_bgm(buffer, version);
            break;
        case SerializeThings.AUDIO_SE:
            Stuff.game_data_location[GameDataCategories.SE] = Stuff.game_data_current_file.GUID;
            serialize_load_audio_se(buffer, version);
            break;
        case SerializeThings.MESHES:
            Stuff.game_data_location[GameDataCategories.MESH] = Stuff.game_data_current_file.GUID;
            serialize_load_meshes(buffer, version);
            break;
        // game stuff
        case SerializeThings.EVENTS:
            Stuff.game_data_location[GameDataCategories.EVENTS] = Stuff.game_data_current_file.GUID;
            serialize_load_events(buffer, version);
            break;
        case SerializeThings.EVENT_CUSTOM:
            // these are part of events
            serialize_load_event_custom(buffer, version);
            break;
        case SerializeThings.EVENT_PREFAB:
            // these are part of events
            serialize_load_event_prefabs(buffer, version);
            break;
        case SerializeThings.GLOBAL_METADATA:
            Stuff.game_data_location[GameDataCategories.GLOBAL] = Stuff.game_data_current_file.GUID;
            serialize_load_global_meta(buffer, version);
            break;
        case SerializeThings.DATADATA:
            Stuff.game_data_location[GameDataCategories.DATADATA] = Stuff.game_data_current_file.GUID;
            serialize_load_datadata(buffer, version);
            break;
        case SerializeThings.DATA_INSTANCES:
            Stuff.game_data_location[GameDataCategories.DATA_INST] = Stuff.game_data_current_file.GUID;
            serialize_load_data_instances(buffer, version);
            break;
        case SerializeThings.ANIMATIONS:
            Stuff.game_data_location[GameDataCategories.ANIMATIONS] = Stuff.game_data_current_file.GUID;
            serialize_load_animations(buffer, version);
            break;
        case SerializeThings.TERRAIN:
            Stuff.game_data_location[GameDataCategories.TERRAIN] = Stuff.game_data_current_file.GUID;
            serialize_load_terrain(buffer, version);
            break;
        case SerializeThings.MAPS:
            Stuff.game_data_location[GameDataCategories.MAP] = Stuff.game_data_current_file.GUID;
            serialize_load_maps(buffer, version);
            break;
        // map stuff
        case SerializeThings.MAP_META:
            serialize_load_map_contents_meta(buffer, version, Stuff.map.active_map); 
            break;
        case SerializeThings.MAP_BATCH:
            serialize_load_map_contents_batch(buffer, version, Stuff.map.active_map);
            break;
        case SerializeThings.MAP_DYNAMIC:
            serialize_load_map_contents_dynamic(buffer, version, Stuff.map.active_map);
            break;
        #endregion
    }
}

switch (what) {
    case SERIALIZE_DATA_AND_MAP:
        for (var i = 1; i < ds_list_size(Stuff.game_asset_lists); i++) {
            Stuff.game_data_current_file = Stuff.game_asset_lists[| i];
            var next_file_name = proj_path + Stuff.game_data_current_file.internal_name + EXPORT_EXTENSION_ASSETS;
            if (file_exists(next_file_name)) {
                var buffer_next = buffer_load(next_file_name);
                serialize_load(buffer_next, next_file_name, proj_name);
            }
        }
        load_a_map(guid_get(Stuff.game_starting_map));
        break;
}

buffer_delete(buffer);

error_show();