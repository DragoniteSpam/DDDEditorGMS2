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

if (!directory_exists(PATH_TEMP_CODE)) directory_create(PATH_TEMP_CODE);
if (!directory_exists(PATH_AUDIO)) directory_create(PATH_AUDIO);
if (!directory_exists(PATH_PROJECTS)) directory_create(PATH_PROJECTS);

// dummy list that will always exist and be empty
empty_list = ds_list_create();

dt = 0;
time = 0;
time_int = 0;
frames = 0;

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();
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
}

tf = ["False", "True"];
on_off = ["Off", "On"];
color_channels = vector4(0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000);
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

#endregion

#region user settings
save_name = "game";

if (file_exists("projects.json")) {
    all_projects = json_decode(file_get_contents("projects.json"));
} else {
    all_projects = ds_map_create();
    ds_map_add_list(all_projects, "projects", ds_list_create());
}
// @gml update try catch
if (file_exists(FILE_SETTINGS)) {
    var json_buffer = buffer_load(FILE_SETTINGS);
    settings = json_decode(buffer_read(json_buffer, buffer_string));
    buffer_delete(json_buffer);
} else {
    settings = ds_map_create();
    var settings_map = ds_map_create();
    var settings_animation = ds_map_create();
    var settings_terrain = ds_map_create();
    var settings_event = ds_map_create();
    var settings_data = ds_map_create();
    var settings_config = ds_map_create();
    var settings_location = ds_map_create();
    var settings_view = ds_map_create();
    ds_map_add_map(settings, "Map", settings_map);
    ds_map_add_map(settings, "Animation", settings_animation);
    ds_map_add_map(settings, "Terrain", settings_terrain);
    ds_map_add_map(settings, "Event", settings_event);
    ds_map_add_map(settings, "Data", settings_data);
    ds_map_add_map(settings, "Config", settings_config);
    ds_map_add_map(settings, "Location", settings_location);
    ds_map_add_map(settings, "Selection", settings_config);
    ds_map_add_map(settings, "View", settings_view);
}

setting_color = setting_get("Config", "color", c_green);                    // BGR
setting_bezier_precision = setting_get("Config", "bezier", 6);              // preferably keep this between like 4 and 16ish?
setting_npc_animate_rate = setting_get("Config", "npc-speed", 4);           // bool
setting_code_extension = setting_get("Config", "code-ext", 1);              // 0 = txt, 1 = lua
setting_text_extension = setting_get("Config", "text-ext", 0);              // 0 = txt, 1 = md
setting_normal_threshold = setting_get("Config", "normal-threshold", 30);   // degrees
setting_tooltip = setting_get("Config", "tooltip", true);                   // bool
setting_camera_fly_rate = setting_get("Config", "camera-fly", 1);           // 0.5 ... 4
setting_alternate_middle = setting_get("Config", "alt-mid", false);      // bool

setting_location_ddd = setting_get("Location", "ddd", "./");
setting_location_mesh = setting_get("Location", "mesh", "./");
setting_location_terrain = setting_get("Location", "terrain", "./");
setting_location_image = setting_get("Location", "image", "./");
setting_location_audio = setting_get("Location", "audio", "./");
setting_location_tiled = setting_get("Location", "tiled", "./");

setting_selection_mode = setting_get("Selection", "mode", SelectionModes.RECTANGLE);
setting_selection_addition = setting_get("Selection", "addition", false);
setting_selection_fill_type = setting_get("Selection", "fill-type", FillTypes.TILE);
setting_selection_zone_type = setting_get("Selection", "zone-type", MapZoneTypes.CAMERA);
setting_selection_mask = setting_get("Selection", "mask", ETypeFlags.ENTITY_ANY);

setting_view_wireframe = setting_get("View", "wireframe", false);
setting_view_grid = setting_get("View", "grid", true);
setting_view_backface = setting_get("View", "backface", false);
setting_view_texture = setting_get("View", "texture", true);
setting_view_entities = setting_get("View", "entities", true);
setting_view_zones = setting_get("View", "zones", true);
setting_view_lighting = setting_get("View", "lighting", true);
setting_view_gizmos = setting_get("View", "gizmos", true);

if (!EDITOR_FORCE_SINGLE_MODE) {
    var stashed_mode = setting_get("Config", "mode", EDITOR_BASE_MODE);
} else {
    var stashed_mode = EDITOR_BASE_MODE;
}

setting_code_extension_map = [".txt", ".lua"];
setting_text_extension_map = [".txt", ".md"];

setting_hide_warnings = ds_map_create();

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;
#endregion

#region initialize standalone systems
smf_init();
ds_stuff_init();
c_init();
c_world_create();

FMODGMS_Sys_Create();
FMODGMS_Sys_Initialize(32);

fmod_channel = FMODGMS_Chan_CreateChannel();
fmod_sound = noone;
fmod_paused = false;
#endregion

#region asset lists

all_guids = ds_map_create();
all_internal_names = ds_map_create();

spr_character_default = sprite_add(PATH_GRAPHICS + "b_chr_default.png", 0, false, false, 0, 0);

// @gml update lwos, all of them
all_graphic_autotiles = ds_list_create();
all_graphic_tilesets = ds_list_create();
all_graphic_overworlds = ds_list_create();
all_graphic_battlers = ds_list_create();
all_graphic_particles = ds_list_create();
all_graphic_ui = ds_list_create();
all_graphic_etc = ds_list_create();

var surface = surface_create(2048, 2048);
all_graphic_particle_texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_width(surface), false, false, 0, 0);
surface_free(surface);
var surface = surface_create(4096, 4096);
all_graphic_ui_texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_width(surface), false, false, 0, 0);
surface_free(surface);

ds_list_add(all_graphic_tilesets, tileset_create(PATH_GRAPHICS + "b_tileset_overworld_0.png"));

all_events = ds_list_create();
all_event_custom = ds_list_create();
all_event_prefabs = ds_list_create();

switches = ds_list_create();         // [name, value]
variables = ds_list_create();        // [name, value]
for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    ds_list_add(switches, ["Switch" + string(i), false]);
    ds_list_add(variables, ["Variable" + string(i), 0]);
}

all_event_triggers = ds_list_create();
repeat (FLAG_COUNT) {
    ds_list_add(all_event_triggers, "");
}
all_event_triggers[| 0] = "Action Button";
all_event_triggers[| 1] = "Player Touch";
all_event_triggers[| 2] = "Event Touch";
all_event_triggers[| 3] = "Autorun";

all_collision_triggers = ds_list_create();
repeat (FLAG_COUNT) {
    ds_list_add(all_collision_triggers, "");
}
all_collision_triggers[| 0] = "Player";
all_collision_triggers[| 1] = "NPC";

all_asset_flags = ds_list_create();
repeat (FLAG_COUNT) {
    ds_list_add(all_asset_flags, "");
}
all_asset_flags[| 0] = "Bush";
all_asset_flags[| 1] = "Counter";
all_asset_flags[| 2] = "Danger";
all_asset_flags[| 3] = "Save";
all_asset_flags[| 4] = "Water";

all_maps = ds_list_create();

all_bgm = ds_list_create();
all_se = ds_list_create();
all_meshes = ds_list_create();

all_animations = ds_list_create();

all_game_constants = ds_list_create();

all_data = ds_list_create();

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
]);
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
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_switch_data, event_prefab_render_self_switch_name],
    ["State", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_SELF_VARIABLES] = create_event_node_basic("ControlSelfVariable", [
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0],
    ["Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_variable_data, event_prefab_render_self_variable_name],
    ["Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_self_variable_data],
    ["Relative?", DataTypes.BOOL, 0, 1, false, false]
]);
event_prefab[EventNodeTypes.CONTROL_TIME] = create_event_node_basic("ControlTimer", [
    ["Counting Down?", DataTypes.BOOL, 0, 1, false, true],
    ["Initial Time (seconds)", DataTypes.INT, 0, 1, false, 0],
    ["Display?", DataTypes.BOOL, 0, 1, false, false],
    ["Running?", DataTypes.BOOL, 0, 1, false, true],
]);
event_prefab[EventNodeTypes.CONDITIONAL] = create_event_node_basic("Conditional", [
    // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
    ["Type", DataTypes.INT, 0, 1, false, 0],
    ["Index", DataTypes.INT, 0, 1, false, 0],
    ["Comparison", DataTypes.INT, 0, 1, false, 0],
    ["Value", DataTypes.INT, 0, 1, false, 0],
    ["Code", DataTypes.INT, 0, 1, false, 0],
]);
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
    ["Volume", DataTypes.INT, 0, 1, false, 0],
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
    ["Map", DataTypes.MAP, 0, 1, false, 0],
    ["New Name", DataTypes.STRING, 0, 1, false, "Whatever the new name is"],
]);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_TILESET] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_BATTLE_SCENE] = create_event_node_basic("NotYetImplemented", []);
/* */ event_prefab[EventNodeTypes.CHANGE_MAP_PARALLAX] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.SCRIPT] = create_event_node_basic("Script", [
    ["Code", DataTypes.CODE, 0, 1, true, default_lua_event_script]
]);
/* */ event_prefab[EventNodeTypes.AUDIO_CONTORLS] = create_event_node_basic("NotYetImplemented", []);
event_prefab[EventNodeTypes.DEACTIVATE_EVENT] = create_event_node_basic("Deactivate This Event", []);
event_prefab[EventNodeTypes.SET_ENTITY_MESH] = create_event_node_basic("SetEntityMesh", [
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0],
    ["Mesh", DataTypes.MESH, 0, 1, false, 0],
]);
event_prefab[EventNodeTypes.SET_ENTITY_SPRITE] = create_event_node_basic("SetEntitySprite", [
    ["Entity", DataTypes.ENTITY, 0, 1, false, 0],
    ["Sprite", DataTypes.IMG_OVERWORLD, 0, 1, false, 0],
]);
#endregion

#region editor modes (and similar things)
// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
instance_create_depth(0, 0, 0, Controller);
graphics = instance_create_depth(0, 0, 0, EditorGraphics);
// various types of editors
map = instance_create_depth(0, 0, 0, EditorModeMap);
data = instance_create_depth(0, 0, 0, EditorModeData);
event = instance_create_depth(0, 0, 0, EditorModeEvent);
animation = instance_create_depth(0, 0, 0, EditorModeAnimation);
terrain = instance_create_depth(0, 0, 0, EditorModeTerrain);
scribble = instance_create_depth(0, 0, 0, EditorModeScribble);
spart = instance_create_depth(0, 0, 0, EditorModeSpart);
menu = menu_init_main();

instance_deactivate_object(EditorMode);

graphics_create_grids();
instance_deactivate_object(UIThing);

#endregion

#region stuff related to garbage collection
stuff_to_destroy = ds_queue_create();
#endregion

#region end of step actions
schedule_rebuild_master_texture = false;
schedule_view_master_texture = false;
schedule_save = false;

gpu_base_state = gpu_get_state();
#endregion

#region visual stuff

// it'd be nice to put this in EditorModeMap but it could also be summoned from
// elsewhere, so it's going here for now; it's not impossible that the deep future
// will contain a 3D model editor mode but that's at like the bottom of the
// priority list now
mesh_preview = noone;
mesh_x = 0;
mesh_y = 0;
mesh_z = 0;
mesh_xrot = 0;
mesh_yrot = 0;
mesh_zrot = 0;
mesh_scale = 1;

error_log_messages = ds_list_create();
dialogs = ds_list_create();
element_tooltip = noone;
element_tooltip_previous = noone;
element_tooltip_t = -1;

screen_icons = ds_queue_create();
unlit_meshes = ds_queue_create();
#endregion

#region global game settings

game_starting_map = map.active_map.GUID;
game_starting_x = 0;
game_starting_y = 0;
game_starting_z = 0;
game_starting_direction = 0;
game_player_grid = true;
game_battle_style = BattleStyles.TEAM_BASED;
game_lighting_buckets = 100;
game_lighting_default_ambient = c_white;

game_common_effect_code = default_lua_effect_common;

game_notes = "";
game_file_summary = "Write a short summary in Global Game Settings";
game_file_author = "Who made this?";

game_asset_lists = ds_list_create();
// @gml update lightweight objects
var file_default = create_data_file("data", false);
var file_asset = create_data_file("assets", false);
var file_terrain = create_data_file("terrain", true);
ds_list_add(game_asset_lists, file_default, file_asset, file_terrain);

game_data_location = array_create(GameDataCategories.SIZE);
game_data_location[GameDataCategories.AUTOTILES] = file_asset.GUID;
game_data_location[GameDataCategories.TILESETS] = file_asset.GUID;
game_data_location[GameDataCategories.BATTLERS] = file_asset.GUID;
game_data_location[GameDataCategories.OVERWORLDS] = file_asset.GUID;
game_data_location[GameDataCategories.PARTICLES] = file_asset.GUID;
game_data_location[GameDataCategories.UI] = file_asset.GUID;
game_data_location[GameDataCategories.MISC] = file_asset.GUID;
game_data_location[GameDataCategories.BGM] = file_asset.GUID;
game_data_location[GameDataCategories.SE] = file_asset.GUID;
game_data_location[GameDataCategories.MESH] = file_asset.GUID;
game_data_location[GameDataCategories.MAP] = file_default.GUID;
game_data_location[GameDataCategories.GLOBAL] = file_default.GUID;
game_data_location[GameDataCategories.EVENTS]  = file_default.GUID;
game_data_location[GameDataCategories.DATADATA] = file_default.GUID;
game_data_location[GameDataCategories.DATA_INST] = file_default.GUID;
game_data_location[GameDataCategories.ANIMATIONS] = file_default.GUID;
game_data_location[GameDataCategories.TERRAIN] = file_terrain.GUID;

game_data_save_scripts = array_create(GameDataCategories.SIZE);
game_data_save_scripts[GameDataCategories.AUTOTILES] = serialize_save_image_autotiles;
game_data_save_scripts[GameDataCategories.TILESETS] = serialize_save_image_tilesets;
game_data_save_scripts[GameDataCategories.BATTLERS] = serialize_save_image_battlers;
game_data_save_scripts[GameDataCategories.OVERWORLDS] = serialize_save_image_overworlds;
game_data_save_scripts[GameDataCategories.PARTICLES] = serialize_save_image_particles;
game_data_save_scripts[GameDataCategories.UI] = serialize_save_image_ui;
game_data_save_scripts[GameDataCategories.MISC] = serialize_save_image_etc;
game_data_save_scripts[GameDataCategories.BGM] = serialize_save_bgm;
game_data_save_scripts[GameDataCategories.SE] = serialize_save_se;
game_data_save_scripts[GameDataCategories.MESH] = serialize_save_meshes;
game_data_save_scripts[GameDataCategories.MAP] = serialize_save_maps;
game_data_save_scripts[GameDataCategories.GLOBAL] = serialize_save_global_meta;
game_data_save_scripts[GameDataCategories.EVENTS]  = serialize_save_events;
game_data_save_scripts[GameDataCategories.DATADATA] = serialize_save_datadata;
game_data_save_scripts[GameDataCategories.DATA_INST] = serialize_save_data_instances;
game_data_save_scripts[GameDataCategories.ANIMATIONS] = serialize_save_animations;
game_data_save_scripts[GameDataCategories.TERRAIN] = serialize_save_terrain;

game_data_current_file = noone;

// these may all go to different save locations
enum GameDataCategories {
    DATADATA, DATA_INST, GLOBAL,
    ANIMATIONS, EVENTS,
    TERRAIN, MAP,
    AUTOTILES, TILESETS,
    BATTLERS, OVERWORLDS,
    PARTICLES, UI, MISC,
    BGM, SE,
    MESH,
    SIZE
}

#endregion

// default editor mode
switch (stashed_mode) {
    case ModeIDs.MAP: editor_mode_3d(); break;
    case ModeIDs.EVENT: editor_mode_event(); break;
    case ModeIDs.DATA: editor_mode_data(); break;
    case ModeIDs.ANIMATION: editor_mode_animation(); break;
    case ModeIDs.TERRAIN: editor_mode_heightmap(); break;
    case ModeIDs.SCRIBBLE: editor_mode_scribble(); break;
    case ModeIDs.SPART: editor_mode_spart(); break;
}

if (PROJECT_MENU_ENABLED) {
    dialog_create_project_list(noone);
}