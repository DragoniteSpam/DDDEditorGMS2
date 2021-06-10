function project_load(id) {
    var t0 = get_timer();
    
    #region helper functions
    static project_load_data = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Game.data = json.data;
        if (Stuff.data.ui) Stuff.data.ui.el_master.entries = Game.data;
    };
    
    static project_load_global = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Game.meta = json.meta;
        Game.vars = json.vars;
    };
    
    static project_load_images = function(filename, directory) {
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
            var ts = new DataImageTileset();
            ts.LoadJSON(tilesets[i]);
            ts.LoadAsset(directory);
            ds_list_add(Game.graphics.tilesets, ts);
        }
        for (var i = 0; i < array_length(overworlds); i++) {
            var image = new DataImage();
            image.LoadJSON(overworlds[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.overworlds, image);
        }
        for (var i = 0; i < array_length(battlers); i++) {
            var image = new DataImage();
            image.LoadJSON(battlers[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.battlers, image);
        }
        for (var i = 0; i < array_length(particles); i++) {
            var image = new DataImage();
            image.LoadJSON(particles[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.particles, image);
        }
        for (var i = 0; i < array_length(ui); i++) {
            var image = new DataImage();
            image.LoadJSON(ui[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.ui, image);
        }
        for (var i = 0; i < array_length(tile_animations); i++) {
            var image = new DataImage();
            image.LoadJSON(tile_animations[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.tile_animations, image);
        }
        for (var i = 0; i < array_length(etc); i++) {
            var image = new DataImage();
            image.LoadJSON(etc[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.etc, image);
        }
        for (var i = 0; i < array_length(skybox); i++) {
            var image = new DataImage();
            image.LoadJSON(skybox[i]);
            image.LoadAsset(directory);
            ds_list_add(Game.graphics.skybox, image);
        }
    };
    
    static project_load_audio = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var se = json.se;
        var bgm = json.bgm;
        
        for (var i = 0; i < array_length(se); i++) {
            var audio = new DataAudio();
            audio.LoadJSON(se[i]);
            audio.LoadAsset(directory);
            ds_list_add(Game.audio.se, audio);
        }
        
        for (var i = 0; i < array_length(bgm); i++) {
            var audio = new DataAudio();
            audio.LoadJSON(bgm[i]);
            audio.LoadAsset(directory);
            ds_list_add(Game.audio.bgm, audio);
        }
    };
    
    static project_load_meshes = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var meshes = json.meshes;
        
        for (var i = 0; i < array_length(meshes); i++) {
            var mesh = instance_create_depth(0, 0, 0, DataMesh);
            mesh.LoadJSON(meshes[i]);
            mesh.LoadAsset(directory);
            ds_list_add(Stuff.all_meshes, mesh);
        }
    };
    
    static project_load_meshat = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var autotiles = json.autotiles;
        
        for (var i = 0; i < array_length(autotiles); i++) {
            var autotile = new DataMeshAutotile();
            autotile.LoadJSON(autotiles[i]);
            autotile.LoadAsset(directory);
            ds_list_add(Stuff.all_mesh_autotiles, autotile);
        }
    };
    
    static project_load_animations = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var animations = json.animations;
        
        for (var i = 0; i < array_length(animations); i++) {
            var animation = instance_create_depth(0, 0, 0, DataAnimation);
            animation.LoadJSON(animations[i]);
            ds_list_add(Stuff.all_animations, animation);
        }
    };
    
    static project_load_terrain = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var terrain = json.terrain;
        
        Stuff.terrain.LoadJSON(terrain);
        Stuff.terrain.LoadAsset(directory);
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
        
        for (var i = 0; i < array_length(events); i++) {
            var event = instance_create_depth(0, 0, 0, DataEvent);
            event.LoadJSON(events[i]);
            ds_list_add(Stuff.all_events, event);
        }
    };
    
    static project_load_maps = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var maps = json.maps;
        
        for (var i = 0; i < array_length(maps); i++) {
            var map = instance_create_depth(0, 0, 0, DataMapContainer);
            map.LoadJSON(maps[i]);
            map.LoadAsset(directory);
            ds_list_add(Stuff.all_maps, map);
        }
    };
    #endregion
    
    var folder_name = PATH_PROJECTS + id + "/";
    
    #region directories
    var folder_audio_name = folder_name + PROJECT_PATH_AUDIO;
    var folder_image_name = folder_name + PROJECT_PATH_IMAGE;
    var folder_map_name = folder_name + PROJECT_PATH_MAP;
    var folder_mesh_name = folder_name + PROJECT_PATH_MESH;
    var folder_mesh_autotile_name = folder_name + PROJECT_PATH_MESH_AUTOTILE;
    var folder_terrain_name = folder_name + PROJECT_PATH_TERRAIN;
    
    if (!directory_exists(folder_name)) directory_create(folder_name);
    if (!directory_exists(folder_audio_name)) directory_create(folder_audio_name);
    if (!directory_exists(folder_image_name)) directory_create(folder_image_name);
    if (!directory_exists(folder_map_name)) directory_create(folder_map_name);
    if (!directory_exists(folder_mesh_name)) directory_create(folder_mesh_name);
    if (!directory_exists(folder_mesh_autotile_name)) directory_create(folder_mesh_autotile_name);
    if (!directory_exists(folder_terrain_name)) directory_create(folder_terrain_name);
    #endregion
    
    Game.Clear();
    
    var yaml = snap_from_yaml(buffer_read_file(folder_name + "project" + EXPORT_EXTENSION_PROJECT));
    var version = yaml.version;
    Game.meta.project.id = yaml.id;
    Game.meta.project.summary = yaml.summary;
    Game.meta.project.author = yaml.author;
    
    project_load_data(folder_name + "data.json");
    project_load_global(folder_name + "meta.json");
    project_load_images(folder_name + "images.json", folder_image_name);
    project_load_audio(folder_name + "audio.json", folder_audio_name);
    project_load_meshes(folder_name + "meshes.json", folder_mesh_name);
    project_load_meshat(folder_name + "meshautotiles.json", folder_mesh_autotile_name);
    project_load_animations(folder_name + "animations.json");
    project_load_terrain(folder_name + "terrain.json", folder_terrain_name);
    project_load_text(folder_name + "text.json");
    project_load_events(folder_name + "events.json");
    project_load_maps(folder_name + "maps.json", folder_map_name);
}