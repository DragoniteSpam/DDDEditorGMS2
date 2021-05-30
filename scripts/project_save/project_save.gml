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
    
    static save_file = function(filename, text) {
        static buffer = buffer_create(1000, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_text, text);
        buffer_save_ext(buffer, filename, 0, buffer_tell(buffer));
    };
    
    var folder_name = PATH_PROJECTS + Stuff.game_asset_id + "/";
    var folder_audio_name = folder_name + PROJECT_PATH_AUDIO;
    var folder_image_name = folder_name + PROJECT_PATH_IMAGE;
    var folder_map_name = folder_name + PROJECT_PATH_MAP;
    var folder_mesh_name = folder_name + PROJECT_PATH_MESH;
    
    if (!directory_exists(folder_name)) directory_create(folder_name);
    if (!directory_exists(folder_audio_name)) directory_create(folder_audio_name);
    if (!directory_exists(folder_image_name)) directory_create(folder_image_name);
    if (!directory_exists(folder_map_name)) directory_create(folder_map_name);
    if (!directory_exists(folder_mesh_name)) directory_create(folder_mesh_name);
    
    save_file(fn, @"
# The project files for " + Stuff.save_name + @" are not stored here.
# This file simply contains a reference to the ID of the project in local
# storage. If you would like to archive the project as a whole (e.g. to
# send to another computer), go to Export and save the project as a zip.
# If you would like to compile the game files for use in a game, go to 
# Export and save the project as a set of DDD files.

" + snap_to_yaml({
        id: Stuff.game_asset_id,
        summary: Stuff.game_file_summary,
        author: Stuff.game_file_author,
        date: {
            year: current_year,
            month: current_month,
            day: current_day,
            hour: current_hour,
            minute: current_minute,
            second: current_second,
        },
    }, true));
    
    file_copy(fn, folder_name + "project" + EXPORT_EXTENSION_PROJECT);
    save_file(folder_name + "data.json", json_stringify({
        data: project_write_json(Stuff.all_data),
    }));
    save_file(folder_name + "images.json", json_stringify({
        tilesets: project_write_json(Stuff.all_graphic_tilesets),
        overworlds: project_write_json(Stuff.all_graphic_overworlds),
        battlers: project_write_json(Stuff.all_graphic_battlers),
        particles: project_write_json(Stuff.all_graphic_particles),
        ui: project_write_json(Stuff.all_graphic_ui),
        tile_animations: project_write_json(Stuff.all_graphic_tile_animations),
        etc: project_write_json(Stuff.all_graphic_etc),
        skybox: project_write_json(Stuff.all_graphic_skybox),
    }));
    save_file(folder_name + "audio.json", json_stringify({
        se: project_write_json(Stuff.all_se),
        bgm: project_write_json(Stuff.all_bgm),
    }));
    save_file(folder_name + "meshes.json", json_stringify({
        meshes: project_write_json(Stuff.all_meshes),
    }));
    save_file(folder_name + "meshautotiles.json", json_stringify({
        autotiles: project_write_json(Stuff.all_mesh_autotiles),
    }));
    
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
}