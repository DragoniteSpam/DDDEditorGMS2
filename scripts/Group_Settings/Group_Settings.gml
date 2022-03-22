function setting_get(object, name, def) {
    var domain = Settings[$ object];
    if (domain) {
        if (domain[$ name] == undefined) return def;
        return domain[$ name] ?? def;
    }
    
    throw "Setting object not found: " + object;
}

function setting_project_add(filename, id) {
    // this just logs it in projects.json; it doesn't add any of the data files
    for (var i = 0; i < array_length(Stuff.all_projects.projects); i++) {
        if (!Stuff.all_projects.projects[i].legacy && Stuff.all_projects.projects[i].source == filename) {
            return;
        }
    }
    
    array_push(Stuff.all_projects.projects, { name: filename_name(filename_change_ext(filename, "")), source: filename, id: id, legacy: false });
    buffer_write_file(json_stringify(Stuff.all_projects), "projects.json");
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
        mesh: { },
        spart: { },
        hide_warnings: { },
    };
}

Settings.config[$ "color"] ??=                                                  c_green;
Settings.config[$ "focus_alpha"] ??=                                            0;
Settings.config[$ "bezier_precision"] ??=                                       6;
Settings.config[$ "npc_animate_rate"] ??=                                       4;
Settings.config[$ "code_extension"] ??=                                         1;
Settings.config[$ "text_extension"] ??=                                         0;
Settings.config[$ "normal_threshold"] ??=                                       30;
Settings.config[$ "tooltip"] ??=                                                true;
Settings.config[$ "camera_fly_rate"] ??=                                        1;
Settings.config[$ "alternate_middle"] ??=                                       false;
Settings.config[$ "color_world"] ??=                                            c_black;
Settings.config[$ "mode"] ??=                                                   EDITOR_BASE_MODE;
Settings.config[$ "remove_covered_mesh_at"] ??=                                 false;
Settings.config[$ "show_debug_ribbon"] ??=                                      true;

Settings.location[$ "ddd"] ??=                                                  "";
Settings.location[$ "mesh"] ??=                                                 "";
Settings.location[$ "terrain"] ??=                                              "";
Settings.location[$ "image"] ??=                                                "";
Settings.location[$ "gml"] ??=                                                  "";
Settings.location[$ "audio"] ??=                                                "";
Settings.location[$ "text"] ??=                                                 "";
Settings.location[$ "tiled"] ??=                                                "";
Settings.location[$ "project"] ??=                                              "";

Settings.selection[$ "mode"] ??=                                                SelectionModes.RECTANGLE;
Settings.selection[$ "addition"] ??=                                            false;
Settings.selection[$ "fill_type"] ??=                                           FillTypes.TILE;
Settings.selection[$ "zone_type"] ??=                                           MapZoneTypes.CAMERA;
Settings.selection[$ "mask"] ??=                                                ETypeFlags.ENTITY_ANY;
Settings.selection.mesh_autotile_type =                                         NULL;               // this will technically be saved, but ignored on load

Settings.view[$ "wireframe"] ??=                                                false;
Settings.view[$ "grid"] ??=                                                     true;
Settings.view[$ "backface"] ??=                                                 false;
Settings.view[$ "texture"] ??=                                                  true;
Settings.view[$ "entities"] ??=                                                 true;
Settings.view[$ "zones"] ??=                                                    true;
Settings.view[$ "lighting"] ??=                                                 true;
Settings.view[$ "gizmos"] ??=                                                   true;
Settings.view[$ "threed"] ??=                                                   true;

Settings.mesh[$ "draw_position"] ??=                                            { x: 0, y: 0, z: 0 };
Settings.mesh[$ "draw_rotation"] ??=                                            { x: 0, y: 0, z: 0 };
Settings.mesh[$ "draw_scale"] ??=                                               { x: 1, y: 1, z: 1 };
Settings.mesh[$ "draw_meshes"] ??=                                              true;
Settings.mesh[$ "draw_wireframes"] ??=                                          true;
Settings.mesh[$ "draw_textures"] ??=                                            true;
Settings.mesh[$ "draw_vertex_colors"] ??=                                       true;
Settings.mesh[$ "draw_lighting"] ??=                                            false;
Settings.mesh[$ "draw_back_faces"] ??=                                          false;
Settings.mesh[$ "draw_reflections"] ??=                                         false;
Settings.mesh[$ "draw_collision"] ??=                                           false;
Settings.mesh[$ "draw_axes"] ??=                                                true;
Settings.mesh[$ "draw_light_direction"] ??=                                     180;
Settings.mesh[$ "draw_grid"] ??=                                                true;
Settings.mesh[$ "reflect_settings"] ??=                                         MeshReflectionSettings.MIRROR_Y | MeshReflectionSettings.MIRROR_Z | MeshReflectionSettings.REVERSE | MeshReflectionSettings.COLORIZE;
Settings.mesh[$ "reflect_color"] ??=                                            0x7fff6600;

#macro warn_untranslated_strings                                                "EXPORT-UNTRANSLATED"
#macro warn_untranslated_strings_as_is                                          1
#macro warn_untranslated_strings_as_default                                     2