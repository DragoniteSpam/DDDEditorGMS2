/// @param filename
/// @param project-name

var fn = argument[0];
var proj_name = (argument_count > 1) ? argument[1] : filename_change_ext(filename_name(fn), "");

var original = buffer_load(fn);
var erroneous = false;

if (filename_ext(fn) == EXPORT_EXTENSION_DATA) {
	var assetname = filename_change_ext(fn, EXPORT_EXTENSION_ASSETS);
	if (file_exists(assetname)) {
		serialize_load(assetname, proj_name);
	}
}

var buffer = buffer_decompress(original);

// if the file won't decompress, it's probably not compressed
if (buffer < 0) {
    buffer = original;
}

buffer_seek(buffer, buffer_seek_start, 0);

// header
var header = chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8)) + chr(buffer_read(buffer, buffer_u8));

if (header == "DDD") {
	Stuff.save_name = string_replace(filename_name(fn), EXPORT_EXTENSION_DATA, "");
	
    var version = buffer_read(buffer, buffer_u32);
    var last_safe_version = DataVersions.STARTING_POSITION;
	
    if (version < last_safe_version) {
        show_error("We stopped supporting versions of the data file before " + string(last_safe_version) +
            ". This current version is " + string(version) + ". Please find a version of " + filename_name(fn) +
            " made with a more up-to-date version of the editor.", true
        );
	}
    
    var what = buffer_read(buffer, buffer_u8);
    
	Stuff.maps_included = (what == SERIALIZE_DATA_AND_MAP);
        
    switch (what) {
        case SERIALIZE_ASSETS:
            instance_activate_object(Data);
            with (Data) if (file_location = DataFileLocations.ASSET) {
                instance_destroy();
            }
            break;
		case SERIALIZE_DATA_AND_MAP:
        case SERIALIZE_DATA:
            instance_activate_object(Data);
            with (Data) if (file_location = DataFileLocations.DATA) {
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
    
    #region content
    var stop = false;
    while (!stop) {
        var datatype = buffer_read(buffer, buffer_datatype);
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
            case SerializeThings.TERRAIN_HEIGHTMAP: serialize_load_terrain(buffer, version, true); break;
            case SerializeThings.MAPS: serialize_load_maps(buffer, version); break;
            // map stuff
            case SerializeThings.MAP_META: serialize_load_map_contents_meta(buffer, version, Stuff.map.active_map);  break;
            case SerializeThings.MAP_BATCH: serialize_load_map_contents_batch(buffer, version, Stuff.map.active_map); break;
            case SerializeThings.MAP_DYNAMIC: serialize_load_map_contents_dynamic(buffer, version, Stuff.map.active_map); break;
            // end of file
            case SerializeThings.END_OF_FILE: stop = true; break;
        }
    }
    #endregion
	
    switch (what) {
        case SERIALIZE_MAP:
			Stuff.map.active_map = guid_get(Stuff.game_starting_map);
			break;
	}
    
    error_show();
    
	setting_project_add(proj_name);
    setting_project_create_local(proj_name, original, filename_ext(fn));
    game_auto_title();
} else {
    erroneous = true;
}

if (erroneous) {
    dialog_create_notice(noone, "this is a ddd* file but the contents are no good?");
}

/*
 * that's it!
 */

buffer_delete(buffer);
if (buffer != original) {
    buffer_delete(original);
}