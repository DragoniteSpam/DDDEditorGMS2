function setting_get(object, name, def) {
    var domain = Settings[$ object];
    if (domain) {
        if (domain[$ name] == undefined) return def;
        return domain[$ name];
    }
    
    throw "Setting object not found: " + object;
}

function setting_project_add(name) {
    // this just logs it in projects.json; it doesn't add any of the data files
    var exists = false;
    for (var i = 0; i < array_length(Stuff.all_projects.projects); i++) {
        if (Stuff.all_projects.projects[i].name == name) {
            exists = true;
            break;
        }
    }
    if (!exists) {
        array_push(Stuff.all_projects.projects, { name: name, id: Stuff.game_asset_id, legacy: false });
    }
    
    buffer_write_file(json_stringify(Stuff.all_projects), "projects.json");
}

function setting_project_create_local(projname, filename, buffer) {
    var auto_folder = PATH_PROJECTS + projname + "/";
    if (!directory_exists(auto_folder)) {
        directory_create(auto_folder);
    }
    
    buffer_save_ext(buffer, auto_folder + filename, 0, buffer_get_size(buffer));
}

#macro Settings global.__settings
Settings = { };

try {
    var json_buffer = buffer_load(FILE_SETTINGS);
    var loaded = json_parse(buffer_read(json_buffer, buffer_string));
    buffer_delete(json_buffer);
    
    var names = variable_struct_get_names(loaded);
    for (var i = 0; i < array_length(names); i++) {
        Settings[$ string_lower(names[i])] = loaded[$ names[i]];
    }
} catch (e) {
    wtf("Something went wrong loading the settings file:");
    wtf(e);
    Settings = {
        map: { },
        animation: { },
        terrain: { },
        event: { },
        data: { },
        config: { },
        location: { },
        selection: { },
        view: { },
        particle: { },
        mesh: { },
        spart: { },
        hide_warnings: { },
    };
}

if (Settings.config[$ "color"] == undefined)                Settings.config.color = c_green;
if (Settings.config[$ "focus_alpha"] == undefined)          Settings.config.focus_alpha = 0;
if (Settings.config[$ "bezier_precision"] == undefined)     Settings.config.bezier_precision = 6;
if (Settings.config[$ "npc_animate_rate"] == undefined)     Settings.config.npc_animate_rate = 4;
if (Settings.config[$ "code_extension"] == undefined)       Settings.config.code_extension = 1;
if (Settings.config[$ "text_extension"] == undefined)       Settings.config.text_extension = 0;
if (Settings.config[$ "normal_threshold"] == undefined)     Settings.config.normal_threshold = 30;
if (Settings.config[$ "tooltip"] == undefined)              Settings.config.tooltip = true;
if (Settings.config[$ "camera_fly_rate"] == undefined)      Settings.config.camera_fly_rate = 1;
if (Settings.config[$ "alternate_middle"] == undefined)     Settings.config.alternate_middle = false;
if (Settings.config[$ "color_world"] == undefined)          Settings.config.color_world = c_black;
if (Settings.config[$ "mode"] == undefined)                 Settings.config.mode = EDITOR_BASE_MODE;
if (Settings.config[$ "remove_covered_mesh_at"] == undefined)   Settings.config.remove_covered_mesh_at = false;

if (Settings.location[$ "ddd"] == undefined)                Settings.location.ddd = "";
if (Settings.location[$ "mesh"] == undefined)               Settings.location.mesh = "";
if (Settings.location[$ "terrain"] == undefined)            Settings.location.terrain = "";
if (Settings.location[$ "image"] == undefined)              Settings.location.image = "";
if (Settings.location[$ "gml"] == undefined)                Settings.location.gml = "";
if (Settings.location[$ "audio"] == undefined)              Settings.location.audio = "";
if (Settings.location[$ "text"] == undefined)               Settings.location.text = "";
if (Settings.location[$ "tiled"] == undefined)              Settings.location.tiled = "";
if (Settings.location[$ "project"] == undefined)            Settings.location.project = "";

if (Settings.selection[$ "mode"] == undefined)              Settings.selection.mode = SelectionModes.RECTANGLE;
if (Settings.selection[$ "addition"] == undefined)          Settings.selection.addition = false;
if (Settings.selection[$ "fill_type"] == undefined)         Settings.selection.fill_type = FillTypes.TILE;
if (Settings.selection[$ "zone_type"] == undefined)         Settings.selection.zone_type = MapZoneTypes.CAMERA;
if (Settings.selection[$ "mask"] == undefined)              Settings.selection.mask = ETypeFlags.ENTITY_ANY;
Settings.selection.mesh_autotile_type = NULL;               // this will technically be saved, but ignored on load

if (Settings.view[$ "wireframe"] == undefined)              Settings.view.wireframe = false;
if (Settings.view[$ "grid"] == undefined)                   Settings.view.grid = true;
if (Settings.view[$ "backface"] == undefined)               Settings.view.backface = false;
if (Settings.view[$ "texture"] == undefined)                Settings.view.texture = true;
if (Settings.view[$ "entities"] == undefined)               Settings.view.entities = true;
if (Settings.view[$ "zones"] == undefined)                  Settings.view.zones = true;
if (Settings.view[$ "lighting"] == undefined)               Settings.view.lighting = true;
if (Settings.view[$ "gizmos"] == undefined)                 Settings.view.gizmos = true;
if (Settings.view[$ "terrain"] == undefined)                Settings.view.terrain = true;

#macro warn_untranslated_strings "EXPORT-UNTRANSLATED"
#macro warn_untranslated_strings_as_is 1
#macro warn_untranslated_strings_as_default 2