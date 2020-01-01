/// @description setup

#region basic setup

randomize();

etype_objects = [
    Entity,
    EntityTile,
    EntityAutoTile,
    EntityMesh,
    EntityPawn,
    EntityEffect,
    noone,
    EntityMeshTerrain
];

default_lua_map = file_get_contents(PATH_LUA + "map.lua");
default_lua_event_page_condition = file_get_contents(PATH_LUA + "event-page-condition.lua");
default_lua_event_node_conditional = file_get_contents(PATH_LUA + "event-node-conditional.lua");
default_lua_event_script = file_get_contents(PATH_LUA + "event-script.lua");
default_lua_animation = file_get_contents(PATH_LUA + "animation.lua");

easing_equations = [
    ease_none, ease_none, ease_linear,
    ease_quad_i, ease_quad_o, ease_quad_io,
    ease_cube_i, ease_cube_o, ease_cube_io,
    ease_quart_i, ease_quart_o, ease_quart_io,
    ease_quint_i, ease_quint_o, ease_quint_io,
    ease_sine_i, ease_sine_o, ease_sine_io,
    ease_exp_i, ease_exp_o, ease_exp_io,
    ease_circ_i, ease_circ_o, ease_circ_io,
];

// local storage folders

if (!directory_exists(PATH_BACKUP)) directory_create(PATH_BACKUP);
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
    TERRAIN
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

#endregion

#region user settings
save_name = "game";

if (file_exists("projects.json")) {
    all_projects = json_decode(file_get_contents("projects.json"));
} else {
    all_projects = ds_map_create();
    ds_map_add_list(all_projects, "projects", ds_list_create());
}
// @todo gml update try catch
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
setting_backups = setting_get("Config", "backups", 2);                      // 0 (none) through 9 (why would you keep that many backups?)
setting_autosave = setting_get("Config", "autosave", true);                 // bool
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
setting_selection_mask = setting_get("Selection", "mask", SELECTION_MASK_ALL);
setting_mouse_drag_behavior = setting_get("Selection", "drag-behavior", 0);

setting_view_wireframe = setting_get("View", "wireframe", false);
setting_view_grid = setting_get("View", "grid", true);
setting_view_backface = setting_get("View", "backface", false);
setting_view_texture = setting_get("View", "texture", true);
setting_view_entities = setting_get("View", "entities", true);

var stashed_mode = setting_get("Config", "mode", EDITOR_BASE_MODE);

setting_code_extension_map = [".txt", ".lua"];
setting_text_extension_map = [".txt", ".md"];
setting_asset_extension_map = [".dddd", ".ddda"];

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

// @todo gml update lwos
all_graphic_autotiles = ds_list_create();
var default_autotile = instance_create_depth(0, 0, 0, DataImageAutotile);
default_autotile.name = "Grass";
default_autotile.picture = sprite_add(PATH_GRAPHICS + "b_at_default_grass_0.png", 0, true, false, 0, 0);
default_autotile.width = sprite_get_width(default_autotile.picture);
default_autotile.height = sprite_get_height(default_autotile.picture);
ds_list_add(all_graphic_autotiles, default_autotile);

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
ds_list_add(all_event_triggers, "Action Button", "Player Touch", "Event Touch", "Autorun");

all_collision_triggers = ds_list_create();
ds_list_add(all_collision_triggers, "Player", "NPC");

all_maps = ds_list_create();

all_bgm = ds_list_create();
all_se = ds_list_create();
all_meshes = ds_list_create();

all_animations = ds_list_create();

all_game_constants = ds_list_create();

all_data = ds_list_create();
original_data = noone;            // when you're modifying the data types and want to stash the old ones

#endregion

#region autotile settings
autotile_map = ds_map_create();
autotile_map[? 2] = 1;
autotile_map[? 8] = 2;
autotile_map[? 10] = 3;
autotile_map[? 11] = 4;
autotile_map[? 16] = 5;
autotile_map[? 18] = 6;
autotile_map[? 22] = 7;
autotile_map[? 24] = 8;
autotile_map[? 26] = 9;
autotile_map[? 27] = 10;
autotile_map[? 30] = 11;
autotile_map[? 31] = 12;

autotile_map[? 64] = 13;
autotile_map[? 66] = 14;
autotile_map[? 72] = 15;
autotile_map[? 74] = 16;
autotile_map[? 75] = 17;
autotile_map[? 80] = 18;
autotile_map[? 82] = 19;
autotile_map[? 86] = 20;
autotile_map[? 88] = 21;
autotile_map[? 90] = 22;
autotile_map[? 91] = 23;
autotile_map[? 94] = 24;

autotile_map[? 95] = 25;
autotile_map[? 104] = 26;
autotile_map[? 106] = 27;
autotile_map[? 107] = 28;
autotile_map[? 120] = 29;
autotile_map[? 122] = 30;
autotile_map[? 123] = 31;
autotile_map[? 126] = 32;
autotile_map[? 127] = 33;
autotile_map[? 208] = 34;
autotile_map[? 210] = 35;
autotile_map[? 214] = 36;

autotile_map[? 216] = 37;
autotile_map[? 218] = 38;
autotile_map[? 219] = 39;
autotile_map[? 222] = 40;
autotile_map[? 223] = 41;
autotile_map[? 248] = 42;
autotile_map[? 250] = 43;

autotile_map[? 251] = 44;
autotile_map[? 254] = 45;
autotile_map[? 255] = 46;
autotile_map[? 0] = 47;

shd_uniform_at_tex_offset = shader_get_uniform(shd_default_autotile, "texoffset");
shd_value_at_tex_offset = array_create(MAX_AUTOTILE_SHADER_POSITIONS);
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
schedule_view_particle_texture = false;
schedule_view_ui_texture = false;
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

#endregion

#region global game settings

game_starting_map = map.active_map.GUID;
game_starting_x = 0;
game_starting_y = 0;
game_starting_z = 0;
game_starting_direction = 0;
game_player_grid = true;
game_battle_style = BattleStyles.TEAM_BASED;

game_include_terrain = true;

game_notes = "";

game_asset_lists = ds_list_create();
// @todo gml update lightweight objects - filename, extension, compressed?
var file_data = create_data_file("data", DataExtensions.DDDD, false);
var file_asset = create_data_file("assets", DataExtensions.DDDA, false);
var file_terrain = create_data_file("terrain", DataExtensions.DDDA, true);
ds_list_add(game_asset_lists, file_data, file_asset);

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
game_data_location[GameDataCategories.MAP] = file_data.GUID;
game_data_location[GameDataCategories.GLOBAL] = file_data.GUID;
game_data_location[GameDataCategories.EVENTS]  = file_data.GUID;
game_data_location[GameDataCategories.DATADATA] = file_data.GUID;
game_data_location[GameDataCategories.ANIMATIONS] = file_data.GUID;
game_data_location[GameDataCategories.TERRAIN] = file_terrain.GUID;

// these may all go to different save locations
enum GameDataCategories {
    AUTOTILES, TILESETS,
    BATTLERS, OVERWORLDS,
    PARTICLES, UI, MISC,
    BGM, SE,
    MESH,
    MAP,
    GLOBAL, EVENTS, DATADATA, ANIMATIONS, TERRAIN
}

enum DataExtensions {
    DDDD,
    DDDA
}

#endregion

// default editor mode
switch (stashed_mode) {
    case ModeIDs.MAP: editor_mode_3d(); break;
    case ModeIDs.EVENT: editor_mode_event(); break;
    case ModeIDs.DATA: editor_mode_data(); break;
    case ModeIDs.ANIMATION: editor_mode_animation(); break;
    case ModeIDs.TERRAIN: editor_mode_heightmap(); break;
}

// the autosave/load is nice, BUT it will make the game break if there's an error
// in either of them. so either do a LOT of validation or have a way to clear the
// autosaves if problems happen.

if (setting_autosave) {
    var project_list = all_projects[? "projects"];
    // @todo gml update try catch
    if (project_list != undefined) {
        dialog_create_project_list(noone);
    }
}