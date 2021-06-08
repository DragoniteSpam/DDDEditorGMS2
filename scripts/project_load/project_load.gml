function project_load(id) {
    #region helper functions
    static project_load_data = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Game.data = json.data;
    };
    
    static project_load_global = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Game.meta = json.meta;
        Game.vars = json.vars;
    };
    
    static project_load_images = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var tilesets = json.tilesets;
        var overworlds = json.overworlds;
        var battlers = json.battlers;
        var particles = json.particles;
        var ui = json.ui;
        var tile_animations = json.tile_animations;
        var etc = json.etc;
        var skybox = json.skybox;
        
        for (var i = 0; i < array_length(tilesets); i++) {
            var ts = instance_create_depth(0, 0, 0, DataTileset);
            ts.LoadJSON(tilesets[i]);
            ds_list_add(Stuff.all_graphic_tilesets, ts);
        }
        for (var i = 0; i < array_length(overworlds); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(overworlds[i]);
            ds_list_add(Stuff.all_graphic_overworlds, ts);
        }
        for (var i = 0; i < array_length(battlers); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(battlers[i]);
            ds_list_add(Stuff.all_graphic_battlers, ts);
        }
        for (var i = 0; i < array_length(particles); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(particles[i]);
            ds_list_add(Stuff.all_graphic_particles, ts);
        }
        for (var i = 0; i < array_length(ui); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(ui[i]);
            ds_list_add(Stuff.all_graphic_ui, ts);
        }
        for (var i = 0; i < array_length(tile_animations); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(tile_animations[i]);
            ds_list_add(Stuff.all_graphic_tile_animations, ts);
        }
        for (var i = 0; i < array_length(etc); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(etc[i]);
            ds_list_add(Stuff.all_graphic_etc, ts);
        }
        for (var i = 0; i < array_length(skybox); i++) {
            var ts = instance_create_depth(0, 0, 0, DataImage);
            ts.LoadJSON(skybox[i]);
            ds_list_add(Stuff.all_graphic_skybox, ts);
        }
    };
    
    static project_load_audio = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var se = json.se;
        var bgm = json.bgm;
    };
    
    static project_load_meshes = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var meshes = json.meshes;
    };
    
    static project_load_meshat = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var autotiles = json.autotiles;
    };
    
    static project_load_animations = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var animations = json.animations;
    };
    
    static project_load_terrain = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var terrain = json.terrain;
    };
    
    static project_load_text = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Stuff.all_languages = json.lang.langs;
        Stuff.all_localized_text = json.lang.data;
        language_refresh_ui();
    };
    
    static project_load_events = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var events = json.events;
    };
    
    static project_load_maps = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var maps = json.maps;
    };
    #endregion
    var folder_name = PATH_PROJECTS + id + "/";
    
    var yaml = snap_from_yaml(buffer_read_file(folder_name + "project" + EXPORT_EXTENSION_PROJECT));
    var version = yaml.version;
    Game.meta.project.id = yaml.id;
    Game.meta.project.summary = yaml.summary;
    Game.meta.project.author = yaml.author;
    
    project_load_data(folder_name + "data.json");
    project_load_global(folder_name + "meta.json");
    project_load_images(folder_name + "images.json");
    project_load_audio(folder_name + "audio.json");
    project_load_meshes(folder_name + "meshes.json");
    project_load_meshat(folder_name + "meshautotiles.json");
    project_load_animations(folder_name + "animations.json");
    project_load_terrain(folder_name + "terrain.json");
    project_load_text(folder_name + "text.json");
    project_load_events(folder_name + "events.json");
    project_load_maps(folder_name + "maps.json");
}