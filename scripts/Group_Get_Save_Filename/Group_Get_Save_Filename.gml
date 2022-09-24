function __get_save_filename_generic(filter, name, directory, title, set) {
    var path = get_save_filename_ext(filter, name, directory, title);
    
    if (path != "") {
        directory = filename_dir(path);
        if (string_length(directory) > 0) set(directory);
    }
    
    return path;
}

function get_save_filename_image(name) {
    return __get_save_filename_generic("Image files|*.png", name, Settings.location.image, "Select an image", function(directory) {
        Settings.location.image = directory;
    });
}

function get_save_filename_dddd(name) {
    return __get_save_filename_generic("DDD game data files|*" + EXPORT_EXTENSION_DATA, name, Settings.location.ddd, "Select a data file", function(directory) {
        Settings.location.ddd = directory;
    });
}

function get_save_filename_project(name) {
    return __get_save_filename_generic("DDD project files|*" + EXPORT_EXTENSION_PROJECT, name, Settings.location.project, "Select a project file", function(directory) {
        Settings.location.project = directory;
    });
}

function get_save_filename_gml(name) {
    return __get_save_filename_generic("GML code files|*.gml", name, Settings.location.gml, "Save a code file", function(directory) {
        Settings.location.gml = directory;
    });
}

function get_save_filename_mesh(name, filter = "Any valid mesh|*.d3d;*.gmmod;*.obj;*.vbuff|Game Maker model files|*.d3d;*.gmmod|Wavefront Object files|*.obj|Vertex buffers|*.vbuff") {
    return __get_save_filename_generic(filter, name, Settings.location.mesh, "Select a mesh", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_save_filename_mesh_full(name, filter = "Any valid mesh|*.d3d;*.gmmod;*.obj;*.vbuff;*.derg|Game Maker model files|*.d3d;*.gmmod|Wavefront Object files|*.obj|Vertex buffers|*.vbuff|Vertex buffer collections|*.derg") {
    return __get_save_filename_generic(filter, name, Settings.location.mesh, "Select a mesh", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_save_filename_mesh_autotile(name) {
    return __get_save_filename_generic("Mesh Autotile files|*.ddd_atm", name, Settings.location.mesh, "Select a mesh autotile collection", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_save_filename_terrain(name) {
    return __get_save_filename_generic("Terrain files|*.dddt", name, Settings.location.terrain, "Select a terrain file", function(directory) {
        Settings.location.terrain = directory;
    });
}

function get_save_filename_text(name) {
    return __get_save_filename_generic("Localization files|*.json;*.csv", name, Settings.location.text, "Select a localization file", function(directory) {
        Settings.location.text = directory;
    });
}