function get_save_filename_image(name) {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("Image files (*.png)|*.png", name, Stuff.settings.location.image, "Select an image");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.image = dir;
            setting_set("Location", "image", dir);
        }
    }
    
    return path;
}

function get_save_filename_dddd(name) {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("DDD game data files|*" + EXPORT_EXTENSION_DATA, name, Stuff.settings.location.ddd, "Select a data file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.ddd = dir;
            setting_set("Location", "ddd", dir);
        }
    }
    
    return path;
}

function get_save_filename_gml(name) {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("GML code files|*.gml", name, Stuff.settings.location.gml, "Save a code file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.gml = dir;
            setting_set("Location", "gml", dir);
        }
    }
    
    return path;
}

function get_save_filename_mesh(name, filter) {
    if (name == undefined) name = "";
    if (filter == undefined) filter = "Any valid mesh|*.d3d;*.gmmod;*.obj;*.vbuff|Game Maker model files|*.d3d;*.gmmod|Wavefront Object files|*.obj|Vertex buffers|*.vbuff";
    var path = get_save_filename_ext(filter, name, Stuff.settings.location.mesh, "Select a mesh");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.mesh = dir;
            setting_set("Location", "mesh", dir);
        }
    }
    
    return path;
}

function get_save_filename_mesh_autotile() {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", name, Stuff.settings.location.mesh, "Select a mesh autotile collection");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.mesh = dir;
            setting_set("Location", "mesh", dir);
        }
    }
    
    return path;
}

function get_save_filename_mesh_qma() {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("quack model archive files (*.qma)|*.qma", name, Stuff.settings.location.mesh, "Select a file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.mesh = dir;
            setting_set("Location", "mesh", dir);
        }
    }
    
    return path;
}

function get_save_filename_mesh_vrax() {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("drago's old file format (*.vrax)|*.vrax", name, Stuff.settings.location.mesh, "Select an vrax file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.mesh = dir;
            setting_set("Location", "mesh", dir);
        }
    }
    
    return path;
}

function get_save_filename_terrain(name) {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("Terrain files (*.dddt)|*.dddt", name, Stuff.settings.location.terrain, "Select a terrain file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.terrain = dir;
            setting_set("Location", "terrain", dir);
        }
    }
    
    return path;
}

function get_save_filename_text(name) {
    if (name == undefined) name = "";
    var path = get_save_filename_ext("Localization files (*.json;*.csv)|*.json;*.csv", name, Stuff.settings.location.text, "Select a localization file");
    
    if (path != "") {
        var dir = filename_dir(path);
        if (string_length(dir) > 0) {
            Stuff.settings.location.text = dir;
            setting_set("Location", "text", dir);
        }
    }
    
    return path;
}