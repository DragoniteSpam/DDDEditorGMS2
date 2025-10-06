function project_load(id) {
    debug_timer_start();
    
    #region helper functions
    static project_load_data = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var data = json.data;
        
        for (var i = 0; i < array_length(data); i++) {
            array_push(Game.data, new DataClass(data[i]));
        }
        
        Stuff.data.ui.Refresh();
    };
    
    static project_load_global = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Game.meta = json.meta;
        Game.vars = json.vars;
        
        // at one point these were stored as structs; this is no longer the
        // case, as it makes identifying if two export locations are the same
        // rather messy
        for (var i = 0; i < array_length(Game.meta.export.locations); i++) {
            if (!is_numeric(Game.meta.export.locations[i])) Game.meta.export.locations[i] = 0;
        }
        
        Game.meta.export[$ "vertex_format"] ??= VertexFormatData.STANDARD;
        Game.meta.export[$ "flags"] ??= 0;
        Game.vars[$ "effect_markers"] ??= 0;
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
            var ts = new DataImageTileset(tilesets[i]);
            ts.LoadAsset(directory);
            array_push(Game.graphics.tilesets, ts);
        }
        for (var i = 0; i < array_length(overworlds); i++) {
            var image = new DataImage(overworlds[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.overworlds, image);
        }
        for (var i = 0; i < array_length(battlers); i++) {
            var image = new DataImage(battlers[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.battlers, image);
        }
        for (var i = 0; i < array_length(particles); i++) {
            var image = new DataImage(particles[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.particles, image);
        }
        for (var i = 0; i < array_length(ui); i++) {
            var image = new DataImage(ui[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.ui, image);
        }
        for (var i = 0; i < array_length(tile_animations); i++) {
            var image = new DataImage(tile_animations[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.tile_animations, image);
        }
        for (var i = 0; i < array_length(etc); i++) {
            var image = new DataImage(etc[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.etc, image);
        }
        for (var i = 0; i < array_length(skybox); i++) {
            var image = new DataImage(skybox[i]);
            image.LoadAsset(directory);
            array_push(Game.graphics.skybox, image);
        }
    };
    
    static project_load_audio = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var se = json.se;
        var bgm = json.bgm;
        
        for (var i = 0; i < array_length(se); i++) {
            var audio = new DataAudio(se[i]);
            audio.LoadAsset(directory);
            array_push(Game.audio.se, audio);
        }
        
        for (var i = 0; i < array_length(bgm); i++) {
            var audio = new DataAudio(bgm[i]);
            audio.LoadAsset(directory);
            array_push(Game.audio.bgm, audio);
        }
    };
    
    static project_load_meshes = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var meshes = json.meshes;
        var terrain = json[$ "terrain"];
        
        for (var i = 0; i < array_length(meshes); i++) {
            var mesh = new DataMesh(meshes[i]);
            mesh.LoadAsset(directory);
            array_push(Game.meshes, mesh);
        }
        
        if (terrain != undefined) {
            for (var i = 0; i < array_length(terrain); i++) {
                var mesh = new DataMesh(terrain[i]);
                mesh.LoadAsset(directory);
                array_push(Game.mesh_terrain, mesh);
            }
        }
    };
    
    static project_load_meshat = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var autotiles = json.autotiles;
        
        for (var i = 0; i < array_length(autotiles); i++) {
            var autotile = new DataMeshAutotile(autotiles[i]);
            autotile.LoadAsset(directory);
            array_push(Game.mesh_autotiles, autotile);
        }
    };
    
    static project_load_animations = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var animations = json.animations;
        
        for (var i = 0; i < array_length(animations); i++) {
            array_push(Game.animations, new DataAnimation(animations[i]));
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
        Game.languages.names = json.lang.langs;
        Game.languages.text = json.lang.data;
        language_refresh_ui();
    };
    
    static project_load_events = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var events = json.events;
        var custom = json.custom;
        var prefabs = json.prefabs;
        
        array_resize(Game.events.events, 0);
        
        for (var i = 0; i < array_length(custom); i++) {
            array_push(Game.events.custom, new DataEventNodeCustom(custom[i]));
        }
        for (var i = 0; i < array_length(prefabs); i++) {
            array_push(Game.events.prefabs, new DataEventNode(prefabs[i], undefined));
        }
        for (var i = 0; i < array_length(events); i++) {
            array_push(Game.events.events, new DataEvent(events[i]));
        }
    };
    
    static project_load_maps = function(filename, directory) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        var maps = json.maps;
        
        array_resize(Game.maps, 0);
        for (var i = 0; i < array_length(maps); i++) {
            array_push(Game.maps, new DataMap(maps[i], directory));
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
    if (yaml[$ "save_name"] != undefined) {
        Stuff.save_name = yaml.save_name;
        game_auto_title();
    }
    
    project_load_global(folder_name + "meta.json");
    project_load_data(folder_name + "data.json");
    project_load_images(folder_name + "images.json", folder_image_name);
    project_load_audio(folder_name + "audio.json", folder_audio_name);
    project_load_meshes(folder_name + "meshes.json", folder_mesh_name);
    project_load_meshat(folder_name + "meshautotiles.json", folder_mesh_autotile_name);
    project_load_animations(folder_name + "animations.json");
    project_load_terrain(folder_name + "terrain.json", folder_terrain_name);
    project_load_text(folder_name + "text.json");
    project_load_events(folder_name + "events.json");
    project_load_maps(folder_name + "maps.json", folder_map_name);
    
    try {
        Game.maps[0].Load();
    } catch (e) {
        show_debug_message("Error loading primary map (is there one?): " + e.message);
    }
    
    Stuff.mesh.ui.Refresh();
    
    Stuff.AddStatusMessage("Loading project \"" + Stuff.save_name + "\" took " + debug_timer_finish());
}