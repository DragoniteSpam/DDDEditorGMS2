function project_load(id) {
    var directory = PATH_PROJECTS + id + "/";
    
    var yaml = snap_from_yaml(buffer_read_file(directory + "project" + EXPORT_EXTENSION_PROJECT));
    var version = yaml.version;
    Stuff.project.id = yaml.id;
    Stuff.project.summary = yaml.summary;
    Stuff.project.author = yaml.author;
}