function project_save() {
    var fn = get_save_filename_project(Stuff.save_name);
    if (fn == "") return;
    
    static project_write_json = function(data_list) {
        var json = { };
        for (var i = 0, n = ds_list_size(data_list); i < n; i++) {
            var data_json = data_list[| i].CreateJSON();
            json[$ data_json.guid] = data_json;
        }
        return json;
    };
    
    static save_file = function(filename, text) {
        static buffer = buffer_create(1000, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_text, text);
        buffer_save_ext(buffer, filename, 0, buffer_tell(buffer));
    };
    
    var main_yaml = @"
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
    }, true);
    
    save_file(fn, main_yaml);
    
    var folder_name = PATH_PROJECTS + "/" + Stuff.game_asset_id;
    var folder_audio_name = folder_name + "/" + PROJECT_PATH_AUDIO;
    var folder_image_name = folder_name + "/" + PROJECT_PATH_IMAGE;
    var folder_map_name = folder_name + "/" + PROJECT_PATH_MAP;
    var folder_mesh_name = folder_name + "/" + PROJECT_PATH_MESH;
    
    if (!directory_exists(folder_name)) {
        directory_create(folder_name);
    }
    
    if (!directory_exists(folder_audio_name)) {
        directory_create(folder_audio_name);
    }
    
    if (!directory_exists(folder_image_name)) {
        directory_create(folder_image_name);
    }
    
    if (!directory_exists(folder_map_name)) {
        directory_create(folder_map_name);
    }
    
    if (!directory_exists(folder_mesh_name)) {
        directory_create(folder_mesh_name);
    }
    
    save_file(folder_name + "/data.json", json_stringify(project_write_json(Stuff.all_data)));
}