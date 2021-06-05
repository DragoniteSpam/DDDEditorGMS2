function project_load(id) {
    var directory = PATH_PROJECTS + id + "/";
    
    var yaml = snap_from_yaml(buffer_read_file(directory + "project" + EXPORT_EXTENSION_PROJECT));
    var version = yaml.version;
    Stuff.game_asset_id = yaml.id;
    Stuff.game_file_summary = yaml.summary;
    Stuff.game_file_author = yaml.author;
}