function project_save() {
    var fn = get_save_filename_project(Stuff.save_name);
    if (fn == "") return;
    
    var id_file = file_text_open_write(fn);
    file_text_write_string(id_file, Stuff.game_asset_id);
    file_text_close(id_file);
    
    var folder_name = PATH_PROJECTS + "/" + Stuff.game_asset_id;
    
    if (!directory_exists(folder_name)) {
        directory_create(folder_name);
    }
}