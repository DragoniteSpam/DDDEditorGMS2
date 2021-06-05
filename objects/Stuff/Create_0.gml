/// @description setup

#region basic setup

randomize();

default_lua_map = file_get_contents(PATH_LUA + "map.lua");
default_lua_event_page_condition = file_get_contents(PATH_LUA + "event-page-condition.lua");
default_lua_event_node_conditional = file_get_contents(PATH_LUA + "event-node-conditional.lua");
default_lua_event_script = file_get_contents(PATH_LUA + "event-script.lua");
default_lua_animation = file_get_contents(PATH_LUA + "animation.lua");
default_lua_effect_common = file_get_contents(PATH_LUA + "global-effect-common.lua");

// local storage folders

if (!directory_exists(PATH_TEMP)) directory_create(PATH_TEMP);
if (!directory_exists(PATH_AUDIO)) directory_create(PATH_AUDIO);
if (!directory_exists(PATH_PROJECTS)) directory_create(PATH_PROJECTS);

// dummy list that will always exist and be empty
empty_list = ds_list_create();

dt = 0;
time = 0;
time_int = 0;
frames = 0;

mouse_3d_lock = false;
mode = noone;

enum ModeIDs {
    MAP,
    EVENT,
    DATA,
    ANIMATION,
    TERRAIN,
    SCRIBBLE,
    SPART,
    DOODLE,
    PARTICLE,
    MESH,
    TEXT,
}

tf = ["False", "True"];
on_off = ["Off", "On"];
color_channels = [0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000];
comparison_text = ["<", "<=", "==", ">=", ">", "!="];
color_lookup = [c_red, c_green, c_blue, c_orange, c_aqua, c_fuchsia, c_purple, c_teal];
direction_lookup = [270, 180, 0, 90];

// these are constants but we're allowed to change them here
tile_width = 32;
tile_height = 32;
tile_depth = 32;
// uv size, not 3D size
tile_size = 32;

default_camera = camera_get_default();

is_quitting = false;
files_dropped = [];

#endregion

#region user settings
save_name = "game";

if (file_exists("projects.json")) {
    all_projects = json_parse(file_get_contents("projects.json"));
} else {
    all_projects = { projects: [] };
}

code_extension_map = [".txt", ".lua", ".gml"];
text_extension_map = [".txt", ".md"];

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;
#endregion

#region initialize standalone systems
smf_init();

//dotdae_init();
wtf("re-add the dotdae thing eventually");

FMODGMS_Sys_Create();
FMODGMS_Sys_Initialize(32);

fmod_channel = FMODGMS_Chan_CreateChannel();
fmod_sound = -1;
#endregion

#region asset lists
all_guids = { };
guid_current = 0;
all_internal_names = ds_map_create();

spr_character_default = sprite_add(PATH_GRAPHICS + "b_chr_default.png", 0, false, false, 0, 0);

all_graphic_tilesets = ds_list_create();
all_graphic_overworlds = ds_list_create();
all_graphic_battlers = ds_list_create();
all_graphic_particles = ds_list_create();
all_graphic_ui = ds_list_create();
all_graphic_tile_animations = ds_list_create();
all_graphic_etc = ds_list_create();
all_graphic_skybox = ds_list_create();

var surface = surface_create(2048, 2048);
all_graphic_particle_texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_width(surface), false, false, 0, 0);
surface_free(surface);
surface = surface_create(4096, 4096);
all_graphic_ui_texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_width(surface), false, false, 0, 0);
surface_free(surface);

tileset_create(PATH_GRAPHICS + DEFAULT_TILESET);
all_graphic_tilesets[| 0].name = "Default";

all_events = ds_list_create();
all_event_custom = ds_list_create();
all_event_prefabs = ds_list_create();

all_maps = ds_list_create();

all_bgm = ds_list_create();
all_se = ds_list_create();
all_meshes = ds_list_create();
all_mesh_autotiles = ds_list_create();

all_animations = ds_list_create();

all_data = ds_list_create();

all_languages = ["English"];

/*
 * example:
 * {
 *      "English": {
 *          "string1": "string1",
 *          "string2": "string2"
 *      },
 *      "Portuguese": {
 *          "string1": "texto1",
 *          "string2": "texto2"
 *      }
 * }
 */
all_localized_text = { English: { } };

#endregion

#region prefab events
event_prefab[EventNodeTypes.INPUT_TEXT] = create_event_node_basic("InputText", [
    ["Help Text", DataTypes.STRING, 0, 1, false, "For example, \"Please enter your name\""],
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_input_type_data, event_prefab_render_input_variable_name],
    ["Kind", DataTypes.INT, 0, 1, false, 0, omu_event_attain_input_type_data, event_prefab_render_input_type_name],
    ["Char Limit", DataTypes.INT, 0, 1, false, 16, omu_event_attain_input_type_data]
]);
event_prefab[EventNodeTypes.SHOW_SCROLLING_TEXT] = create_event_node_basic("TextCrawl", [
    ["Text", DataTypes.STRING, 0, 250, false, "Text that is shown in the text crawl goes here"],
]);
event_prefab[EventNodeTypes.SHOW_CHOICES] = create_event_node_basic("ShowChoices", [
    // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
    ["Message", DataTypes.STRING, 0, 16, false, "Option 1"],
    ["ID", DataTypes.INT, 0, 16, false, 0],
], ["Option 1", "Option 2"]);
event_prefab[EventNodeTypes.CONTROL_SWITCHES] = create_event_node_basic("ControlGlobalSwitch", [
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_switch_data, event_prefab_render_switch_name],
    ["State", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_VARIABLES] = create_event_node_basic("ControlGlobalVariable", [
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_variable_data, event_prefab_render_variable_name],
    ["Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_variable_data],
    ["Relative?", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_SELF_SWITCHES] = create_event_node_basic("ControlSelfSwitch", [
    ["Entity", DataTypes.ENTITY],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_switch_data, event_prefab_render_self_switch_name],
    ["State", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_SELF_VARIABLES] = create_event_node_basic("ControlSelfVariable", [
    ["Entity", DataTypes.ENTITY],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_variable_data, event_prefab_render_self_variable_name],
    ["Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_self_variable_data],
    ["Relative?", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_TIME] = create_event_node_basic("ControlTimer", [
    ["Counting Down?", DataTypes.BOOL, 0, 1, false, true],
    ["Initial Time (seconds)", DataTypes.INT],
    ["Display?", DataTypes.BOOL, 0, 1, false, false],
    ["Running?", DataTypes.BOOL, 0, 1, false, true],
]);
event_prefab[EventNodeTypes.CONDITIONAL] = create_event_node_basic("Conditional", [
    // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
    ["Type", DataTypes.INT],
    ["Index", DataTypes.INT],
    ["Comparison", DataTypes.INT],
    ["Value", DataTypes.INT],
    ["Code", DataTypes.INT],
], ["Success", "Fail"]);
event_prefab[EventNodeTypes.INVOKE_EVENT] = create_event_node_basic("WillNotBeImplemented", []);
event_prefab[EventNodeTypes.COMMENT] = create_event_node_basic("ImplementedElsewhere", []);
event_prefab[EventNodeTypes.WAIT] = create_event_node_basic("Wait", [["Seconds", DataTypes.FLOAT, 0, 1, false, 1]]);
event_prefab[EventNodeTypes.TRANSFER_PLAYER] = create_event_node_basic("TransferPlayer", [
    ["Map", DataTypes.MAP, 0, 1, false, 0, omu_event_attain_map_data, event_prefab_render_map_name],
    ["X", DataTypes.INT, 0, 1, false, 0, omu_event_attain_map_data],
    ["Y", DataTypes.INT, 0, 1, false, 0, omu_event_attain_map_data],
    ["A", DataTypes.INT, 0, 1, false, 0, omu_event_attain_map_data],
    ["Direction", DataTypes.INT, 0, 1, false, 0, omu_event_attain_map_data, event_prefab_render_map_direction_name],
    ["FadeColor", DataTypes.COLOR, 0, 1, false, c_black, omu_event_attain_map_data],
    ["FadeTime", DataTypes.FLOAT, 0, 1, false, 1, omu_event_attain_map_data],
]);
/* */ event_prefab[EventNodeTypes.SET_ENTITY_LOCATION] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SCROLL_MAP] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.SET_MOVEMENT_ROUTE] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.TINT_SCREEN] = create_event_node_basic("TintScreen", [
    ["Color", DataTypes.COLOR, 0, 1, false, c_white],
    ["Alpha", DataTypes.FLOAT, 0, 1, false, 1],
    ["Time", DataTypes.FLOAT, 0, 1, false, 1],
    ["Wait?", DataTypes.BOOL, 0, 1, false, true],
]);
event_prefab[EventNodeTypes.FLASH_SCREEN] = create_event_node_basic("WillNotBeImplemented", []);
event_prefab[EventNodeTypes.SHAKE_SCREEN] = create_event_node_basic("ShakeScreen", [
    ["PowerX", DataTypes.FLOAT, 0, 1, false, 0.25],
    ["PowerY", DataTypes.FLOAT, 0, 1, false, 0.25],
    ["Speed", DataTypes.FLOAT, 0, 1, false, 0.25],
    ["Duration", DataTypes.FLOAT, 0, 1, false, 1],
    ["Wait?", DataTypes.BOOL, 0, 1, false, true],
]);
event_prefab[EventNodeTypes.PLAY_BGM] = create_event_node_basic("PlayBGM", [
    ["BGM", DataTypes.AUDIO_BGM, 0],
    ["Volume", DataTypes.INT, 0, 1, false, 100],
    ["Pitch", DataTypes.INT, 0, 1, false, 100]
]);
event_prefab[EventNodeTypes.FADE_BGM] = create_event_node_basic("FadeBGM", [
    ["Volume", DataTypes.INT],
    ["Time", DataTypes.FLOAT, 0, 1, false, 1],
    ["Stop On Complete?", DataTypes.BOOL, 0, 1, false, true]
]);
event_prefab[EventNodeTypes.RESUME_BGM] = create_event_node_basic("ResumeAutomaticBGM", []);
// if you want fancier audio controls for sound effects, make an advanced event - i'm not going to write the FMOD effects into the basic one
event_prefab[EventNodeTypes.PLAY_SE] = create_event_node_basic("PlaySoundEffect", [
    ["Sound Effect", DataTypes.AUDIO_SE, 0],
    ["Volume", DataTypes.INT, 0, 1, false, 100],
    ["Pitch", DataTypes.INT, 0, 1, false, 100]
]);
event_prefab[EventNodeTypes.STOP_SE] = create_event_node_basic("StopAllSoundEffects", []);
/* */ event_prefab[EventNodeTypes.RETURN_TO_TITLE] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.CHANGE_MAP_DISPLAY_NAME] = create_event_node_basic("ChangeMapDisplayName", [
    ["Map", DataTypes.MAP],
    ["New Name", DataTypes.STRING, 0, 1, false, "Whatever the new name is"],
]);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_TILESET] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_BATTLE_SCENE] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_PARALLAX] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.SCRIPT] = create_event_node_basic("Script", [
    ["Code", DataTypes.CODE, 0, 1, true, default_lua_event_script]
]);
/* */ event_prefab[EventNodeTypes.AUDIO_CONTORLS] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.DEACTIVATE_EVENT] = create_event_node_basic("Deactivate This Event Page", []);
event_prefab[EventNodeTypes.SET_ENTITY_MESH] = create_event_node_basic("SetEntityMesh", [
    ["Entity", DataTypes.ENTITY],
    ["Mesh", DataTypes.MESH],
]);
event_prefab[EventNodeTypes.SET_ENTITY_SPRITE] = create_event_node_basic("SetEntitySprite", [
    ["Entity", DataTypes.ENTITY],
    ["Sprite", DataTypes.IMG_OVERWORLD],
]);
event_prefab[EventNodeTypes.SET_MESH_ANIMATION] = create_event_node_basic("SetEntityMeshAnimation", [
    ["Entity", DataTypes.ENTITY],
    ["Speed", DataTypes.FLOAT, 0, 1, false, 30],
    ["EndAction", DataTypes.INT, 0, 1, false, 0, omu_event_attain_mesh_anim_end_action, event_prefab_render_mesh_animation_end_action],
]);
event_prefab[EventNodeTypes.SCHEDULE_EVENT] = create_event_node_basic("ScheduleEvent", [
    ["Entity", DataTypes.ENTITY],
    ["Time", DataTypes.FLOAT],
], ["Outbound", "Scheduled Event"]);

enum EventNodeTypes {
    ENTRYPOINT,
    TEXT,
    CUSTOM,
    INPUT_TEXT, SHOW_SCROLLING_TEXT,
    CONTROL_SWITCHES, CONTROL_VARIABLES, CONTROL_SELF_SWITCHES, CONTROL_SELF_VARIABLES, CONTROL_TIME,
    CONDITIONAL, INVOKE_EVENT, COMMENT, WAIT,
    TRANSFER_PLAYER, SET_ENTITY_LOCATION, SCROLL_MAP, SET_MOVEMENT_ROUTE,
    TINT_SCREEN, FLASH_SCREEN, SHAKE_SCREEN,
    PLAY_BGM, FADE_BGM, RESUME_BGM, PLAY_SE, STOP_SE,
    RETURN_TO_TITLE, CHANGE_MAP_DISPLAY_NAME, CHANGE_MAP_TILESET, CHANGE_MAP_BATTLE_SCENE, CHANGE_MAP_PARALLAX,
    SCRIPT, AUDIO_CONTORLS, DEACTIVATE_EVENT, SET_MESH_ANIMATION, SCHEDULE_EVENT, ADVANCED3, ADVANCED4, ADVANCED5, ADVANCED6, ADVANCED7,
    // i forgot to put this one with the other text nodes
    SHOW_CHOICES, SET_ENTITY_SPRITE, SET_ENTITY_MESH,
}
#endregion

#region editor modes (and similar things)
// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
instance_create_depth(0, 0, 0, Controller);
all_modes = ds_list_create();
graphics = instance_create_depth(0, 0, 0, EditorGraphics);
// various types of editors
map = instance_create_depth(0, 0, 0, EditorModeMap);
data = instance_create_depth(0, 0, 0, EditorModeData);
event = instance_create_depth(0, 0, 0, EditorModeEvent);
animation = instance_create_depth(0, 0, 0, EditorModeAnimation);
terrain = instance_create_depth(0, 0, 0, EditorModeTerrain);
mesh_ed = instance_create_depth(0, 0, 0, EditorModeMeshes);
scribble = instance_create_depth(0, 0, 0, EditorModeScribble);
spart = instance_create_depth(0, 0, 0, EditorModeSpart);
doodle = instance_create_depth(0, 0, 0, EditorModeDoodle);
particle = instance_create_depth(0, 0, 0, EditorModeParticle);
text = new EditorModeText();
menu = RIBBON_MENU();

instance_deactivate_object(EditorMode);

graphics_create_grids();
instance_deactivate_object(UIThing);

#endregion

#region stuff related to garbage collection
stuff_to_destroy = ds_queue_create();
c_object_cache = ds_queue_create();
#endregion

#region end of step actions
schedule_rebuild_autotile_texture = false;
schedule_save = false;
schedule_export = false;

gpu_base_state = gpu_get_state();
#endregion

#region visual stuff

// it'd be nice to put this in EditorModeMap but it could also be summoned from
// elsewhere, so it's going here for now; it's not impossible that the deep future
// will contain a 3D model editor mode but that's at like the bottom of the
// priority list now
mesh_x = 0;
mesh_y = 0;
mesh_z = 0;
mesh_xrot = 0;
mesh_yrot = 0;
mesh_zrot = 0;
mesh_scale = 1;

dialogs = ds_list_create();
drawn_dialog_shade = false;
element_tooltip = noone;
element_tooltip_previous = noone;
element_tooltip_t = -1;

screen_icons = ds_queue_create();
unlit_meshes = ds_queue_create();

default_pawn = instance_create_depth(0, 0, 0, DataImage);
instance_deactivate_object(default_pawn);
default_pawn.texture_exclude = true;
default_pawn.picture = spr_pawn_missing;
default_pawn.width = sprite_get_width(default_pawn.picture);
default_pawn.height = sprite_get_height(default_pawn.picture);
default_pawn.hframes = 4;
default_pawn.vframes = 4;
default_pawn.aframes = 0;
default_pawn.aspeed = 0;
default_pawn.picture_with_frames = -1;
data_image_npc_frames(default_pawn);
#endregion

#region global game settings
game_asset_lists = ds_list_create();
var file_default = new DataFile("data", false, true);
var file_asset = new DataFile("assets", false, false);
var file_terrain = new DataFile("terrain", true, false);
ds_list_add(game_asset_lists, file_default, file_asset, file_terrain);

game_data_location = array_create(GameDataCategories.__COUNT);
game_data_location[GameDataCategories.TILE_ANIMATIONS] = file_asset;
game_data_location[GameDataCategories.TILESETS] = file_asset;
game_data_location[GameDataCategories.BATTLERS] = file_asset;
game_data_location[GameDataCategories.OVERWORLDS] = file_asset;
game_data_location[GameDataCategories.PARTICLES] = file_asset;
game_data_location[GameDataCategories.UI] = file_asset;
game_data_location[GameDataCategories.SKYBOX] = file_asset;
game_data_location[GameDataCategories.MISC] = file_asset;
game_data_location[GameDataCategories.BGM] = file_asset;
game_data_location[GameDataCategories.SE] = file_asset;
game_data_location[GameDataCategories.MESH] = file_asset;
game_data_location[GameDataCategories.MESH_AUTOTILES] = file_asset;
game_data_location[GameDataCategories.MAP] = file_default;
game_data_location[GameDataCategories.GLOBAL] = file_default;
game_data_location[GameDataCategories.EVENTS]  = file_default;
game_data_location[GameDataCategories.DATADATA] = file_default;
game_data_location[GameDataCategories.DATA_INST] = file_default;
game_data_location[GameDataCategories.ANIMATIONS] = file_default;
game_data_location[GameDataCategories.TERRAIN] = file_terrain;
game_data_location[GameDataCategories.LANGUAGE_TEXT] = file_default;

game_data_save_scripts = array_create(GameDataCategories.__COUNT);
game_data_save_scripts[GameDataCategories.TILE_ANIMATIONS] = serialize_save_image_tile_animations;
game_data_save_scripts[GameDataCategories.TILESETS] = serialize_save_image_tilesets;
game_data_save_scripts[GameDataCategories.BATTLERS] = serialize_save_image_battlers;
game_data_save_scripts[GameDataCategories.OVERWORLDS] = serialize_save_image_overworlds;
game_data_save_scripts[GameDataCategories.PARTICLES] = serialize_save_image_particles;
game_data_save_scripts[GameDataCategories.UI] = serialize_save_image_ui;
game_data_save_scripts[GameDataCategories.SKYBOX] = serialize_save_image_skybox;
game_data_save_scripts[GameDataCategories.MISC] = serialize_save_image_etc;
game_data_save_scripts[GameDataCategories.BGM] = serialize_save_bgm;
game_data_save_scripts[GameDataCategories.SE] = serialize_save_se;
game_data_save_scripts[GameDataCategories.MESH] = serialize_save_meshes;
game_data_save_scripts[GameDataCategories.MESH_AUTOTILES] = serialize_save_mesh_autotiles;
game_data_save_scripts[GameDataCategories.MAP] = serialize_save_maps;
game_data_save_scripts[GameDataCategories.GLOBAL] = serialize_save_global_meta;
game_data_save_scripts[GameDataCategories.EVENTS]  = serialize_save_events;
game_data_save_scripts[GameDataCategories.DATADATA] = serialize_save_datadata;
game_data_save_scripts[GameDataCategories.DATA_INST] = serialize_save_data_instances;
game_data_save_scripts[GameDataCategories.ANIMATIONS] = serialize_save_animations;
game_data_save_scripts[GameDataCategories.TERRAIN] = serialize_save_terrain;
game_data_save_scripts[GameDataCategories.LANGUAGE_TEXT] = serialize_save_language;

game_data_current_file = noone;

// these may all go to different save locations
// comment lines denote asset sections to make this list easier to read
enum GameDataCategories {
/**/DATADATA,           // core
    DATA_INST,
    GLOBAL,
/**/ANIMATIONS,         // other
    EVENTS,
    TERRAIN,
    MAP,
/**/TILE_ANIMATIONS,    // image assets
    TILESETS,
    BATTLERS,
    OVERWORLDS,
    PARTICLES,
    UI,
    SKYBOX,
    MISC,
/**/BGM,                // audio assets
    SE,
/**/MESH,               // mesh
/**/LANGUAGE_TEXT,      // appended later
    MESH_AUTOTILES,
    __COUNT
}

#endregion

#region data types
enum DataTypes {
    INT,                // input
    ENUM,               // list
    FLOAT,              // input
    STRING,             // input
    BOOL,               // checkbox
    DATA,               // list
    CODE,               // opens in text editor
    COLOR,              // color picker
    MESH,               // list
    IMG_TEXTURE,        // list
    TILE,               
    IMG_TILE_ANIMATION, // list
    AUDIO_BGM,          // list
    AUDIO_SE,           // list
    ANIMATION,          // list
    ENTITY,             // list (refid)
    MAP,                // list
    IMG_BATTLER,        // list
    IMG_OVERWORLD,      // list
    IMG_PARTICLE,       // list
    IMG_UI,             // list
    IMG_ETC,            // list
    EVENT,              // list
    IMG_SKYBOX,         // list
    MESH_AUTOTILE,      // list
    ASSET_FLAG,         // button (-> bitfield)
    _COUNT
}

data_type_default_values = [
    0,
    NULL,
    0,
    "",
    false,
    NULL,
    "",
    c_black,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    0,
];

/*
 * if you want to add a new data type, you need to:
 *  0. add it to the list here
 *  1. add it to the following enums, if it's a serialized field:
 *           - SerializeThings
 *           - GameDataCategories
 *           - entry in dialog_create_settings_data_asset_files (with color)
 *  2. case in omu_data_list_add
 *  3. case in uivc_list_data_list_select
 *  4. case in draw_event_node - in four different switch statements (can that be simplified?)
 *  5. case in ui_init_game_data_activate (the big one)
 *  6. case in ui_init_game_data_refresh - in two different switch statements
 *  7. case in dialog_create_data_instance_property_list - in two different switch statemetns
 *  8. case in serialize_load_data_instances
 *          and the equivalent in the game
 *  9. case in serialize_save_data_instances
 *  10. case in serialize_load_events
 *          and the equivalent in the game
 *  11. case in serialize_save_events
 *  12. text in the lists in dialog_create_select_data_types_ext (and the color, if applicable)
 *  13. case in draw_active_event
 *  14. case in uimu_data_add_data
 *  15. case in dialog_entity_data_enable_by_type
 *  16. case in serialize_save_entity
 *  17. the equilvalent in serialize_load_entity
 *          and the equivalent in the game
 *  18. case in serialize_load_event_prefabs
 *          event prefabs are IGNORED in the game
 *  19. case in serialize_save_event_prefabs
 *  20. case in serialize_save_map_contents_meta
 *  21. case in serialize_load_map_contents_meta
 *          and the equivalent in the game
 *  22. Stuff.Create - game data location and game data save scripts
 *  23. enum DataVersions - you most likely will need a new data version to handle the new data
 *  24. serialize_load - read the data out
 */
#endregion

// default editor mode
switch (EDITOR_FORCE_SINGLE_MODE ? EDITOR_BASE_MODE : Settings.config.mode) {
    case ModeIDs.MAP: editor_mode_3d(); break;
    case ModeIDs.EVENT: editor_mode_event(); break;
    case ModeIDs.DATA: editor_mode_data(); break;
    case ModeIDs.ANIMATION: editor_mode_animation(); break;
    case ModeIDs.TERRAIN: editor_mode_heightmap(); break;
    case ModeIDs.SCRIBBLE: editor_mode_scribble(); break;
    case ModeIDs.SPART: editor_mode_spart(); break;
    case ModeIDs.DOODLE: editor_mode_doodle(); break;
    case ModeIDs.PARTICLE: editor_mode_particle(); break;
    case ModeIDs.MESH: editor_mode_meshes(); break;
    case ModeIDs.TEXT: editor_mode_text(); break;
}

if (PROJECT_MENU_ENABLED) {
    dialog_create_project_list(noone);
}