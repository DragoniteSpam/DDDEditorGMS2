function __get_open_filename_general(filter, name, directory, title, set) {
    var path = get_open_filename_ext(filter, name, directory, title);
    
    if (file_exists(path)) {
        directory = filename_dir(path);
        if (string_length(directory) > 0) set(directory);
    }
    
    return path;
}

function get_open_filename_mesh_autotile() {
    return __get_open_filename_general("Mesh Autotile files|*.ddd_atm", "", Settings.location.mesh, "Select a mesh autotile collection", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_open_filename_audio() {
    return __get_open_filename_general("Audio files|*.ogg;*.mid", "", Settings.location.audio, "Select an audio file", function(directory) {
        Settings.location.audio = directory;
    });
}

function get_open_filename_ddd() {
    return __get_open_filename_general("DDD project files|*" + EXPORT_EXTENSION_PROJECT, "", Settings.location.project, "Select a game project file", function(directory) {
        Settings.location.project = directory;
    });
}

function get_open_filename_project() {
    return __get_open_filename_general("DDD project files|*" + EXPORT_EXTENSION_PROJECT, "", Settings.location.project, "Select a game project file", function(directory) {
        Settings.location.project = directory;
    });
}

function get_open_filename_image() {
    return __get_open_filename_general("Image files|*.png;*.bmp|PNG files|*.png|Bitmap files|*.bmp", "", Settings.location.image, "Select an image", function(directory) {
        Settings.location.image = directory;
    });
}

function get_open_filename_mesh() {
    var filter = (EDITOR_BASE_MODE != ModeIDs.MESH) ?
        "Any valid mesh file|*.d3d;*.gmmod;*.obj;*.mtl;*.dae;*.smf;|Game Maker model files|*.d3d;*.gmmod|Wavefront Object files|*.obj;*.mtl|Collada models|*.dae" :
        "Any valid mesh file|*.d3d;*.gmmod;*.obj;*.mtl;|Game Maker model files|*.d3d;*.gmmod|Wavefront Object files|*.obj;*.mtl";
    return __get_open_filename_general(filter, "", Settings.location.mesh, "Select a 3D model file", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_open_filename_mesh_d3d() {
    return __get_open_filename_general("Game Maker model files|*.d3d;*.gmmod", "", Settings.location.mesh, "Select a mesh", function(directory) {
        Settings.location.mesh = directory;
    });
}

function get_open_filename_terrain() {
    return __get_open_filename_general("Terrain files|*.dddt;*.ddd_terrain", "", Settings.location.terrain, "terrain file", function(directory) {
        Settings.location.terrain = directory;
    });
}

function get_open_filename_tiled() {
    return __get_open_filename_general("Tiled JSON files|*.json", "", Settings.location.tiled, "Select a Tiled file", function(directory) {
        Settings.location.tiled = directory;
    });
}

function get_open_filename_text() {
    return __get_open_filename_general("Localization files|*.json;*.csv", "", Settings.location.text, "Select a localization file", function(directory) {
        Settings.location.text = directory;
    });
}