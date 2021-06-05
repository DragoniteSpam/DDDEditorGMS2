function project_load(id) {
    #region helper functions
    static project_load_data = function(filename) {
        
    };
    
    static project_load_global = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        
        Game.project.notes =                    json.core.notes;
        Game.start.map =                        json.core.start.map;
        Game.start.x =                          json.core.start.x;
        Game.start.y =                          json.core.start.y;
        Game.start.z =                          json.core.start.z;
        Game.start.direction =                  json.core.start.direction;
        
        Game.lighting.ambient =                 json.core.lighting.ambient;
        
        Game.grid.chunk_size =                  json.core.grid.chunk_size;
        Game.grid.snap =                        json.core.grid.player_snap;
        
        Game.screen.width =                     json.core.base_screen.width;
        Game.screen.height =                    json.core.base_screen.height;
        
        Game.start.title =                      json.core.title.map;
        
        Game.switches =                         json.core.switches;
        Game.variables =                        json.core.variables;
        Game.all_constants =               json.core.constants;
        Game.all_event_triggers =               json.core.triggers;
        Game.all_asset_flags =                  json.core.flags;
    };
    
    static project_load_images = function(filename) {
        
    };
    
    static project_load_audio = function(filename) {
        
    };
    
    static project_load_meshes = function(filename) {
        
    };
    
    static project_load_meshat = function(filename) {
        
    };
    
    static project_load_animations = function(filename) {
        
    };
    
    static project_load_terrain = function(filename) {
        
    };
    
    static project_load_text = function(filename) {
        var json = json_parse(buffer_read_file(filename));
        var version = json.version;
        Stuff.all_languages = json.lang.langs;
        Stuff.all_localized_text = json.lang.data;
        language_refresh_ui();
    };
    
    static project_load_events = function(filename) {
        
    };
    
    static project_load_maps = function(filename) {
        
    };
    #endregion
    var folder_name = PATH_PROJECTS + id + "/";
    
    var yaml = snap_from_yaml(buffer_read_file(folder_name + "project" + EXPORT_EXTENSION_PROJECT));
    var version = yaml.version;
    Game.project.id = yaml.id;
    Game.project.summary = yaml.summary;
    Game.project.author = yaml.author;
    
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