/// @param buffer

var buffer = argument0;
var erroneous = false;

buffer_seek(buffer, buffer_seek_start, 0);

// the header's already been validated by serialize_load_base
buffer_read(buffer, buffer_u8);
buffer_read(buffer, buffer_u8);
buffer_read(buffer, buffer_u8);

var version = buffer_read(buffer, buffer_u32);
var what = buffer_read(buffer, buffer_u8);

Stuff.maps_included = (what == SERIALIZE_DATA_AND_MAP);

switch (what) {
    case SERIALIZE_ASSETS:
        instance_activate_object(Data);
        with (Data) if (file_location == DataFileLocations.ASSET) {
            instance_destroy();
        }
        break;
	case SERIALIZE_DATA_AND_MAP:
    case SERIALIZE_DATA:
        instance_activate_object(Data);
        with (Data) if (file_location == DataFileLocations.DATA) {
            instance_destroy();
        }
        // clear all data - data has already been destroyed so you just have to clear them
        ds_list_clear(Stuff.all_events);
        ds_list_clear(Stuff.all_event_custom);
        ds_list_clear(Stuff.all_event_prefabs);
        ds_list_clear(Stuff.all_data);
		ds_list_clear(Stuff.all_game_constants);
        // these contain arrays, which are garbage collected
        ds_list_clear(Stuff.variables);
        ds_list_clear(Stuff.switches);
        // graphics
        for (var i = 0; i < ds_list_size(Stuff.all_graphic_autotiles); i++) {
            instance_destroy(Stuff.all_graphic_autotiles[| i]);
        }
        ds_list_clear(Stuff.all_graphic_autotiles);
		// anything else?
		Stuff.map.active_map = noone;
        Stuff.game_include_terrain = false;
        break;
    case SERIALIZE_MAP:
		instance_activate_object(DataMapContainer);
		instance_destroy(DataMapContainer);
		Stuff.map.active_map = instance_create_depth(0, 0, 0, DataMapContainer);
		Stuff.map.active_map.contents = instance_create_depth(0, 0, 0, MapContents);
		instance_deactivate_object(Stuff.map.active_map.contents);
        break;
}

// the editor doesn't care that much about the addresses of each chunk
if (version >= DataVersions.DATA_CHUNK_ADDRESSES) {
    var addr_content = buffer_read(buffer, buffer_u64);
    buffer_seek(buffer, buffer_seek_start, addr_content);
}

while (true) {
    var datatype = buffer_read(buffer, buffer_datatype);
    if (datatype == SerializeThings.END_OF_FILE) {
        break;
    }
    
    switch (datatype) {
        // assets
        case SerializeThings.IMAGE_AUTOTILES: serialize_load_image_autotiles(buffer, version); break;
        case SerializeThings.IMAGE_TILESET: serialize_load_image_tilesets(buffer, version); break;
        case SerializeThings.IMAGE_BATTLERS: serialize_load_image_battlers(buffer, version); break;
        case SerializeThings.IMAGE_OVERWORLD: serialize_load_image_overworlds(buffer, version); break;
        case SerializeThings.IMAGE_PARTICLES: serialize_load_image_particles(buffer, version); break;
        case SerializeThings.IMAGE_UI: serialize_load_image_ui(buffer, version); break;
        case SerializeThings.IMAGE_MISC: serialize_load_image_etc(buffer, version); break;
        case SerializeThings.AUDIO_BGM: serialize_load_audio_bgm(buffer, version); break;
        case SerializeThings.AUDIO_SE: serialize_load_audio_se(buffer, version); break;
        case SerializeThings.MESHES: serialize_load_meshes(buffer, version); break;
        // game stuff
        case SerializeThings.EVENTS: serialize_load_events(buffer, version); break;
        case SerializeThings.GLOBAL_METADATA: serialize_load_global_meta(buffer, version); break;
        case SerializeThings.DATADATA: serialize_load_datadata(buffer, version); break;
        case SerializeThings.DATA_INSTANCES: serialize_load_data_instances(buffer, version); break;
        case SerializeThings.EVENT_CUSTOM: serialize_load_event_custom(buffer, version); break;
		case SerializeThings.EVENT_PREFAB: serialize_load_event_prefabs(buffer, version); break;
        case SerializeThings.ANIMATIONS: serialize_load_animations(buffer, version); break;
        case SerializeThings.TERRAIN: serialize_load_terrain(buffer, version, true); break;
        case SerializeThings.MAPS: serialize_load_maps(buffer, version); break;
        // map stuff
        case SerializeThings.MAP_META: serialize_load_map_contents_meta(buffer, version, Stuff.map.active_map);  break;
        case SerializeThings.MAP_BATCH: serialize_load_map_contents_batch(buffer, version, Stuff.map.active_map); break;
        case SerializeThings.MAP_DYNAMIC: serialize_load_map_contents_dynamic(buffer, version, Stuff.map.active_map); break;
    }
}

switch (what) {
    case SERIALIZE_MAP:
		Stuff.map.active_map = guid_get(Stuff.game_starting_map);
		break;
}

error_show();