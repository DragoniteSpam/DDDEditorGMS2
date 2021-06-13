function project_save() {
    var fn = get_save_filename_project(Stuff.save_name);
    if (fn == "") return;
    
    static project_write_json = function(data_list) {
        var json = array_create(ds_list_size(data_list));
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            json[i] = data_list[| i].CreateJSON();
        }
        return json;
    };
    
    static project_write_json_array = function(data_array) {
        var json = array_create(array_length(data_array));
        for (var i = 0, n = array_length(data_array); i < n; i++) {
            json[i] = data_array[i].CreateJSON();
        }
        return json;
    };
    
    static project_write_json_simple = function(data_list) {
        var json = array_create(ds_list_size(data_list));
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            json[i] = data_list[| i];
        }
        return json;
    };
    
    static project_write_json_simple_array = function(data_array) {
        var json = array_create(array_length(data_array));
        for (var i = 0, n = array_length(data_array); i < n; i++) {
            json[i] = data_array[i];
        }
        return json;
    };
    
    static save_assets = function(folder, data_list) {
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            data_list[| i].SaveAsset(folder);
        }
    };
    
    static project_write_text = function() {
        return {
            langs: Game.languages.names,
            data: Game.languages.text,
        };
    };
    
    var t0 = get_timer();
    var project_id = Game.meta.project.id + "_" + md5_string_utf8(fn);
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
        id: Game.meta.project.id,
        folder: folder_name,
        summary: Game.meta.project.summary,
        author: Game.meta.project.author,
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
        data: Game.data,
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "data.json");
    buffer_write_file(json_stringify({
        meta: Game.meta,
        vars: Game.vars,
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meta.json");
    buffer_write_file(json_stringify({
        tilesets: project_write_json(Game.graphics.tilesets),
        overworlds: project_write_json(Game.graphics.overworlds),
        battlers: project_write_json(Game.graphics.battlers),
        particles: project_write_json(Game.graphics.particles),
        ui: project_write_json(Game.graphics.ui),
        tile_animations: project_write_json(Game.graphics.tile_animations),
        etc: project_write_json(Game.graphics.etc),
        skybox: project_write_json(Game.graphics.skybox),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "images.json");
    buffer_write_file(json_stringify({
        se: project_write_json_simple(Game.audio.se),
        bgm: project_write_json_simple(Game.audio.bgm),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "audio.json");
    buffer_write_file(json_stringify({
        meshes: project_write_json_array(Game.meshes),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meshes.json");
    buffer_write_file(json_stringify({
        autotiles: project_write_json(Game.mesh_autotiles),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "meshautotiles.json");
    buffer_write_file(json_stringify({
        animations: project_write_json_simple_array(Game.animations),
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
        events: project_write_json(Game.events.events),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "events.json");
    buffer_write_file(json_stringify({
        maps: project_write_json(Game.maps),
        version: ProjectSaveVersions._CURRENT - 1,
    }), folder_name + "maps.json");
    
    save_assets(folder_image_name, Game.graphics.tilesets);
    save_assets(folder_image_name, Game.graphics.overworlds);
    save_assets(folder_image_name, Game.graphics.battlers);
    save_assets(folder_image_name, Game.graphics.particles);
    save_assets(folder_image_name, Game.graphics.ui);
    save_assets(folder_image_name, Game.graphics.tile_animations);
    save_assets(folder_image_name, Game.graphics.etc);
    save_assets(folder_image_name, Game.graphics.skybox);
    save_assets(folder_audio_name, Game.audio.se);
    save_assets(folder_audio_name, Game.audio.bgm);
    save_assets(folder_mesh_name, Game.meshes);
    save_assets(folder_mesh_autotile_name, Game.mesh_autotiles);
    save_assets(folder_map_name, Game.maps);
    Stuff.terrain.SaveAsset(folder_terrain_name);
    
    setting_project_add(fn, project_id);
    
    wtf("Saving took " + string((get_timer() - t0) / 1000) + " ms");
}

enum ProjectSaveVersions {
    INITIAL                         = 0x01,
    _CURRENT,
}