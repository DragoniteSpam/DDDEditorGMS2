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
    
    var id_file = file_text_open_write(fn);
    file_text_write_string(id_file, Stuff.game_asset_id);
    file_text_close(id_file);
    
    var folder_name = PATH_PROJECTS + "/" + Stuff.game_asset_id;
    
    if (!directory_exists(folder_name)) {
        directory_create(folder_name);
    }
}