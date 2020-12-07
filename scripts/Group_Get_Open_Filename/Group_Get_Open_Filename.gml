function get_open_filename_mesh_autotile() {
    var path = get_open_filename_ext("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", "", Settings.location.mesh, "Select a mesh autotile collection");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.mesh = dir;
        }
    }
    
    return path;
}

function get_open_filename_audio_effect() {
    var path = get_open_filename_ext("Audio files (*.wav)|*.wav", "", Settings.location.audio, "Select an audio file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.audio = dir;
        }
    }
    
    return path;
}

function get_open_filename_audio_fmod() {
    var path = get_open_filename_ext("Audio files (*.ogg, *.mid)|*.ogg;*.mid", "", Settings.location.audio, "Select an audio file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.audio = dir;
        }
    }
    
    return path;
}

function get_open_filename_ddd() {
    var path = get_open_filename_ext("DDD game files (" + EXPORT_EXTENSION_DATA + ", " + EXPORT_EXTENSION_MAP + ", " + EXPORT_EXTENSION_ASSETS + ")|*" + EXPORT_EXTENSION_DATA + ";*" + EXPORT_EXTENSION_MAP + ";*" + EXPORT_EXTENSION_ASSETS, "", Settings.location.ddd, "Select a game data file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.ddd = dir;
        }
    }
    
    return path;
}

function get_open_filename_image() {
    var path = get_open_filename_ext("Image files (*.png, *.bmp)|*.png;*.bmp|PNG files|*.png|Bitmap files|*.bmp", "", Settings.location.image, "Select an image");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.image = dir;
        }
    }
    
    return path;
}

function get_open_filename_mesh() {
    var path = get_open_filename_ext("Any valid mesh file|*.d3d;*.gmmod;*.obj;*.vrax;*.smf;*.qma;|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj|drago's old file format|*.vrax|drago's newer file format|*.qma|SMF files (advanced)|*.smf", "", Settings.location.mesh, "Select a 3D model file");

    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.mesh = dir;
        }
    }
    
    return path;
}

function get_open_filename_mesh_d3d() {
    var path = get_open_filename_ext("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "", Settings.location.mesh, "Select a mesh");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.mesh = dir;
        }
    }
    
    return path;
}

function get_open_filename_terrain() {
    var path = get_open_filename_ext("Terrain files (*.dddt)|*.dddt;*.ddd_terrain", "", Settings.location.terrain, "terrain file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.terrain = dir;
        }
    }
    
    return path;
}

function get_open_filename_tiled() {
    var path = get_open_filename_ext("Tiled JSON files (*.json)|*.json", "", Settings.location.tiled, "Select a Tiled file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.tiled = dir;
        }
    }
    
    return path;
}

function get_open_filename_text() {
    var path = get_open_filename_ext("Localization files (*.json;*.csv)|*.json;*.csv", "", Settings.location.text, "Select a localization file");
    
    if (file_exists(path)) {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Settings.location.text = dir;
        }
    }
    
    return path;
}