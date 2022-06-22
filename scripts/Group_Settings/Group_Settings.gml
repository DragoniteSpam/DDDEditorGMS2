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
        colors: { },
        hide_warnings: { },
    };
}

Settings[$ "config"] ??=                                                        { };
Settings.config[$ "color_mode"] ??=                                             0;
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
Settings.config[$ "show_status_messages"] ??=                                   true;

Settings[$ "location"] ??=                                                      { };
Settings.location[$ "ddd"] ??=                                                  "";
Settings.location[$ "mesh"] ??=                                                 "";
Settings.location[$ "terrain"] ??=                                              "";
Settings.location[$ "image"] ??=                                                "";
Settings.location[$ "gml"] ??=                                                  "";
Settings.location[$ "audio"] ??=                                                "";
Settings.location[$ "text"] ??=                                                 "";
Settings.location[$ "tiled"] ??=                                                "";
Settings.location[$ "project"] ??=                                              "";

Settings[$ "selection"] ??=                                                     { };
Settings.selection[$ "mode"] ??=                                                MapSelectionModes.RECTANGLE;
Settings.selection[$ "addition"] ??=                                            false;
Settings.selection[$ "fill_type"] ??=                                           FillTypes.TILE;
Settings.selection[$ "zone_type"] ??=                                           MapZoneTypes.CAMERA;
Settings.selection[$ "mask"] ??=                                                ETypeFlags.ENTITY_ANY;
Settings.selection.mesh_autotile_type =                                         NULL;               // this will technically be saved, but ignored on load

Settings[$ "view"] ??=                                                          { };
Settings.view[$ "wireframe"] ??=                                                false;
Settings.view[$ "grid"] ??=                                                     true;
Settings.view[$ "backface"] ??=                                                 false;
Settings.view[$ "texture"] ??=                                                  true;
Settings.view[$ "entities"] ??=                                                 true;
Settings.view[$ "frozen"] ??=                                                   true;
Settings.view[$ "water"] ??=                                                    true;
Settings.view[$ "zones"] ??=                                                    true;
Settings.view[$ "lighting"] ??=                                                 true;
Settings.view[$ "gizmos"] ??=                                                   true;
Settings.view[$ "threed"] ??=                                                   true;

Settings[$ "mesh"] ??=                                                          { };
Settings.mesh[$ "draw_position"] ??=                                            MESH_DEF_VIEW_DRAW_POSITION;
Settings.mesh[$ "draw_rotation"] ??=                                            MESH_DEF_VIEW_DRAW_ROTATION;
Settings.mesh[$ "draw_scale"] ??=                                               MESH_DEF_VIEW_DRAW_SCALE;
Settings.mesh[$ "draw_meshes"] ??=                                              MESH_DEF_VIEW_DRAW_MESHES;
Settings.mesh[$ "draw_textures"] ??=                                            MESH_DEF_VIEW_DRAW_TEXTURES;
Settings.mesh[$ "draw_vertex_colors"] ??=                                       MESH_DEF_VIEW_DRAW_VERTEX_TEXTURES;
Settings.mesh[$ "draw_lighting"] ??=                                            MESH_DEF_VIEW_DRAW_LIGHTING; 
Settings.mesh[$ "draw_back_faces"] ??=                                          MESH_DEF_VIEW_DRAW_BACK_FACES;
Settings.mesh[$ "draw_reflections"] ??=                                         MESH_DEF_VIEW_DRAW_REFLECTIONS;
Settings.mesh[$ "draw_collision"] ??=                                           MESH_DEF_VIEW_DRAW_COLLISION;
Settings.mesh[$ "draw_axes"] ??=                                                MESH_DEF_VIEW_DRAW_AXES;
Settings.mesh[$ "draw_light_direction"] ??=                                     MESH_DEF_VIEW_DRAW_LIGHT_DIRECTION;
Settings.mesh[$ "draw_grid"] ??=                                                MESH_DEF_VIEW_DRAW_GRID;
Settings.mesh[$ "wireframe_alpha"] ??=                                          MESH_DEF_VIEW_WIREFRAME_ALPHA;
Settings.mesh[$ "reflect_settings"] ??=                                         MESH_DEF_REFLECT_SETTINGS;
Settings.mesh[$ "reflect_color"] ??=                                            MESH_DEF_REFLECT_COLOR;
Settings.mesh[$ "combine_obj_submeshes"] ??=                                    MESH_DEF_COMBINE_OBJ_SUBMESHES;
Settings.mesh[$ "draw_3d_view_overlay_text"] ??=                                MESH_DEF_DRAW_3D_VIEW_OVERLAY_TEXT;
Settings.mesh[$ "fuse_textureless_materials"] ??=                               MESH_DEF_FUSE_TEXTURELESS_MATERIALS;

#macro MESH_DEF_VIEW_DRAW_POSITION                                              new Vector3(0, 0, 0)
#macro MESH_DEF_VIEW_DRAW_ROTATION                                              new Vector3(0, 0, 0)
#macro MESH_DEF_VIEW_DRAW_SCALE                                                 new Vector3(1, 1, 1)
#macro MESH_DEF_VIEW_DRAW_MESHES                                                true
#macro MESH_DEF_VIEW_DRAW_TEXTURES                                              true
#macro MESH_DEF_VIEW_DRAW_VERTEX_TEXTURES                                       true
#macro MESH_DEF_VIEW_DRAW_LIGHTING                                              true
#macro MESH_DEF_VIEW_DRAW_BACK_FACES                                            false
#macro MESH_DEF_VIEW_DRAW_REFLECTIONS                                           false
#macro MESH_DEF_VIEW_DRAW_COLLISION                                             false
#macro MESH_DEF_VIEW_DRAW_AXES                                                  true
#macro MESH_DEF_VIEW_DRAW_LIGHT_DIRECTION                                       180
#macro MESH_DEF_VIEW_DRAW_GRID                                                  true
#macro MESH_DEF_VIEW_WIREFRAME_ALPHA                                            1
#macro MESH_DEF_REFLECT_SETTINGS                                                (MeshReflectionSettings.MIRROR_Y | MeshReflectionSettings.MIRROR_Z | MeshReflectionSettings.REVERSE | MeshReflectionSettings.COLORIZE)
#macro MESH_DEF_REFLECT_COLOR                                                   0x7fff6600
#macro MESH_DEF_COMBINE_OBJ_SUBMESHES                                           true
#macro MESH_DEF_DRAW_3D_VIEW_OVERLAY_TEXT                                       true
#macro MESH_DEF_FUSE_TEXTURELESS_MATERIALS                                      true
#macro vk_mesh_editor_overlay_text_toggle                                       ord("O")

#macro COLOR_MODE_DARK_BACK                                                     0x1f1f1f
#macro COLOR_MODE_DARK_DEFAULT                                                  0x5f5f5f
#macro COLOR_MODE_DARK_TEXT                                                     0xffffff
#macro COLOR_MODE_DARK_DISABLED                                                 0x4f4f4f
#macro COLOR_MODE_DARK_HELP_TEXT                                                0x606060
#macro COLOR_MODE_DARK_HOVER                                                    0x4f4f4f
#macro COLOR_MODE_DARK_INPUT_REJECT                                             0x2f2fff
#macro COLOR_MODE_DARK_INPUT_WARN                                               0x3399ff
#macro COLOR_MODE_DARK_LIST_TEXT                                                0xffffff
#macro COLOR_MODE_DARK_PROGRESS_BAR                                             0xff9900
#macro COLOR_MODE_DARK_RADIO_ACTIVE                                             0x009900
#macro COLOR_MODE_DARK_SELECTED                                                 0x4f4f4f

#macro COLOR_MODE_LIGHT_BACK                                                    0xffffff
#macro COLOR_MODE_LIGHT_DEFAULT                                                 0x000000
#macro COLOR_MODE_LIGHT_TEXT                                                    0xe0e0e0
#macro COLOR_MODE_LIGHT_DISABLED                                                0x404040
#macro COLOR_MODE_LIGHT_HELP_TEXT                                               0xffe5ce
#macro COLOR_MODE_LIGHT_HOVER                                                   0x0000ff
#macro COLOR_MODE_LIGHT_INPUT_REJECT                                            0x3399ff
#macro COLOR_MODE_LIGHT_INPUT_WARN                                              0x000000
#macro COLOR_MODE_LIGHT_LIST_TEXT                                               0xff9900
#macro COLOR_MODE_LIGHT_PROGRESS_BAR                                            0x009900
#macro COLOR_MODE_LIGHT_RADIO_ACTIVE                                            0xffb8ac
#macro COLOR_MODE_LIGHT_SELECTED                                                0x339900

Settings[$ "colors"] ??=                                                        { };
Settings.colors[$ "primary"] ??=                                                c_green;
Settings.colors[$ "back"] ??=                                                   (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_BACK : COLOR_MODE_LIGHT_BACK;
Settings.colors[$ "def"] ??=                                                    (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_DEFAULT : COLOR_MODE_LIGHT_DEFAULT;
Settings.colors[$ "text"] ??=                                                   (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_TEXT : COLOR_MODE_LIGHT_TEXT;
Settings.colors[$ "disabled"] ??=                                               (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_DISABLED : COLOR_MODE_LIGHT_DISABLED;
Settings.colors[$ "help_text"] ??=                                              (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_HELP_TEXT : COLOR_MODE_LIGHT_HELP_TEXT;
Settings.colors[$ "hover"] ??=                                                  (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_HOVER : COLOR_MODE_LIGHT_HOVER;
Settings.colors[$ "input_reject"] ??=                                           (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_INPUT_REJECT : COLOR_MODE_LIGHT_INPUT_REJECT;
Settings.colors[$ "input_warn"] ??=                                             (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_INPUT_WARN : COLOR_MODE_LIGHT_INPUT_WARN;
Settings.colors[$ "list_text"] ??=                                              (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_LIST_TEXT : COLOR_MODE_LIGHT_LIST_TEXT;
Settings.colors[$ "progress_bar"] ??=                                           (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_PROGRESS_BAR : COLOR_MODE_LIGHT_PROGRESS_BAR;
Settings.colors[$ "radio_active"] ??=                                           (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_RADIO_ACTIVE : COLOR_MODE_LIGHT_RADIO_ACTIVE;
Settings.colors[$ "sel"] ??=                                                    (Settings.config.color_mode == 0) ? COLOR_MODE_DARK_SELECTED : COLOR_MODE_LIGHT_SELECTED;

#macro warn_untranslated_strings                                                "EXPORT-UNTRANSLATED"
#macro warn_untranslated_strings_as_is                                          1
#macro warn_untranslated_strings_as_default                                     2