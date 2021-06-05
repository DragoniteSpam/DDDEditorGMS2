function project_save() {
    var fn = get_save_filename_project(Stuff.save_name);
    if (fn == "") return;
    
    static project_write_json = function(data_list) {
        var json = array_create(ds_list_size(data_list));
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            var data_json = data_list[| i].CreateJSON();
            json[i] = data_json;
        }
        return json;
    };
    
    static save_assets = function(folder, data_list) {
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            data_list[| i].SaveAsset(folder);
        }
    };
    
    static project_write_global = function() {
        return {
            id: Game.project.id,
            notes: Game.project.notes,
            start: {
                map: Game.start.map,
                x: Game.start.x,
                y: Game.start.y,
                z: Game.start.z,
                direction: Game.start.direction,
            },
            lighting: {
                ambient: Game.lighting.ambient,
            },
            grid: {
                chunk_size: Game.grid.chunk_size,
                player_snap: Game.grid.snap,
            },
            base_screen: {
                width: Game.screen.width,
                height: Game.screen.height,
            },
            title: {
                map: Game.start.title,
            },
            switches: Game.switches,
            variables: Game.variables,
            constants: Game.all_constants,
            triggers: Game.all_event_triggers,
            flags: Game.all_asset_flags,
        };
    };
    
    static project_write_text = function() {
        return {
            langs: Stuff.all_languages,
            data: Stuff.all_localized_text,
        };
    };
    
    var t0 = get_timer();
    var project_id = Game.project.id + "_" + md5_string_utf8(fn);
    var folder_name = PATH_PROJECTS + project_id + "/";
    var folder_audio_name = folder_name + PROJECT_PATH_AUDIO;
    var folder_image_name = folder_name + PROJECT_PATH_IMAGE;
    var folder_map_name = folder_name + PROJECT_PATH_MAP;
    var folder_mesh_name = folder_name + PROJECT_PATH_MESH;
    var folder_mesh_autotile_name = folder_name + PROJECT_PATH_MESH_AUTOTILE;
    var folder_terrain_name = folder_name + PROJECT_PATH_TERRAIN;
    
    if (!directory_exists(folder_name)) directory_create(folder_name);
    if (!directory_exists(folder_audio_name)) directory_create(folder_audio_name);
    if (!directory_exists(folder_image_name)) directory_create(folder_image_name);
    if (!directory_exists(folder_map_name)) directory_create(folder_map_name);
    if (!directory_exists(folder_mesh_name)) directory_create(folder_mesh_name);
    if (!directory_exists(folder_mesh_autotile_name)) directory_create(folder_mesh_autotile_name);
    if (!directory_exists(folder_terrain_name)) directory_create(folder_terrain_name);
    
    buffer_write_file(@"
# The project files for " + Stuff.save_name + @" are not stored here.
# This file simply contains a reference to the ID of the project in local
# storage. If you would like to archive the project as a whole (e.g. to
# send to another computer), go to Export and save the project as a zip.
# If you would like to compile the game files for use in a game, go to 
# Export and save the project as a set of DDD files.

" + snap_to_yaml({
        id: Game.project.id,
        folder: folder_name,
        summary: Game.project.summary,
        author: Game.project.author,
        date: {
            year: current_year,
            month: current_month,
            day: current_day,
            hour: current_hour,
            minute: current_minute,
            second: current_second,
        },
        version: ProjectSaveVersions._CURRENT - 1,
    }, true), fn);
    
    file_copy(fn, folder_name + "project" + EXPORT_EXTENSION_PROJECT);
    buffer_write_file(json_stringify({
        data: project_write_json(Stuff.all_data),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "data.json");
    buffer_write_file(json_stringify({
        core: project_write_global(),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meta.json");
    buffer_write_file(json_stringify({
        tilesets: project_write_json(Stuff.all_graphic_tilesets),
        overworlds: project_write_json(Stuff.all_graphic_overworlds),
        battlers: project_write_json(Stuff.all_graphic_battlers),
        particles: project_write_json(Stuff.all_graphic_particles),
        ui: project_write_json(Stuff.all_graphic_ui),
        tile_animations: project_write_json(Stuff.all_graphic_tile_animations),
        etc: project_write_json(Stuff.all_graphic_etc),
        skybox: project_write_json(Stuff.all_graphic_skybox),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "images.json");
    buffer_write_file(json_stringify({
        se: project_write_json(Stuff.all_se),
        bgm: project_write_json(Stuff.all_bgm),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "audio.json");
    buffer_write_file(json_stringify({
        meshes: project_write_json(Stuff.all_meshes),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meshes.json");
    buffer_write_file(json_stringify({
        autotiles: project_write_json(Stuff.all_mesh_autotiles),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meshautotiles.json");
    buffer_write_file(json_stringify({
        animations: project_write_json(Stuff.all_animations),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "animations.json");
    buffer_write_file(json_stringify({
        terrain: Stuff.terrain.CreateJSON(),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "terrain.json");
    buffer_write_file(json_stringify({
        lang: project_write_text(),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "text.json");
    buffer_write_file(json_stringify({
        events: project_write_json(Stuff.all_events),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "events.json");
    buffer_write_file(json_stringify({
        maps: project_write_json(Stuff.all_maps),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "maps.json");
    
    save_assets(folder_image_name, Stuff.all_graphic_tilesets);
    save_assets(folder_image_name, Stuff.all_graphic_overworlds);
    save_assets(folder_image_name, Stuff.all_graphic_battlers);
    save_assets(folder_image_name, Stuff.all_graphic_particles);
    save_assets(folder_image_name, Stuff.all_graphic_ui);
    save_assets(folder_image_name, Stuff.all_graphic_tile_animations);
    save_assets(folder_image_name, Stuff.all_graphic_etc);
    save_assets(folder_image_name, Stuff.all_graphic_skybox);
    save_assets(folder_audio_name, Stuff.all_se);
    save_assets(folder_audio_name, Stuff.all_bgm);
    save_assets(folder_mesh_name, Stuff.all_meshes);
    save_assets(folder_mesh_autotile_name, Stuff.all_mesh_autotiles);
    save_assets(folder_map_name, Stuff.all_maps);
    Stuff.terrain.SaveAsset(folder_terrain_name);
    
    setting_project_add(fn, project_id);
    
    wtf("Saving took " + string((get_timer() - t0) / 1000) + " ms");
}

enum ProjectSaveVersions {
    INITIAL                         = 0x01,
    _CURRENT,
}