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
    
    static save_json = function(filename, json) {
        static buffer = buffer_create(1000, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_text, json_stringify(json));
        buffer_save_ext(buffer, filename, 0, buffer_tell(buffer));
    };
    
    var id_file = file_text_open_write(fn);
    file_text_write_string(id_file, Stuff.game_asset_id);
    file_text_close(id_file);
    
    var folder_name = PATH_PROJECTS + "/" + Stuff.game_asset_id;
    
    if (!directory_exists(folder_name)) {
        directory_create(folder_name);
    }
}