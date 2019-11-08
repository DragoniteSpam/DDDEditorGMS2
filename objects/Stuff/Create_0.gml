/// @description setup

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

if (!directory_exists(PATH_BACKUP_DATA)) directory_create(PATH_BACKUP_DATA);
if (!directory_exists(PATH_BACKUP_MAP)) directory_create(PATH_BACKUP_MAP);
if (!directory_exists(PATH_BACKUP_ASSET)) directory_create(PATH_BACKUP_ASSET);
if (!directory_exists(PATH_TEMP_CODE)) directory_create(PATH_TEMP_CODE);
if (!directory_exists(PATH_AUDIO)) directory_create(PATH_AUDIO);
if (!directory_exists(PATH_PROJECTS)) directory_create(PATH_PROJECTS);

// dummy list that will always exist and be empty
empty_list = ds_list_create();

smf_init();

alarm[0] = 1200;

/// this is basically World/Settings

randomize();

// persistent stuff
dt = 0;
time = 0;
time_int = 0;
frames = 0;

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();
mouse_3d_lock = false;

all_guids = ds_map_create();
all_internal_names = ds_map_create();

tf = ["False", "True"];
on_off = ["Off", "On"];
color_channels = [0x0000ff, 0x00ff00, 0xff0000];

comparison_text = ["<", "<=", "==", ">=", ">", "!="];

// these are constants but we're allowed to change them here
tile_width = 32;
tile_height = 32;
tile_depth = 32;

// uv size, not 3D size
tile_size = 32;

dimensions = Dimensions.THREED;

spr_character_default = sprite_add(PATH_GRAPHICS + "b_chr_default.png", 0, false, false, 0, 0);

// this sounds like a reasonable limit, it's not based on anything though
all_graphic_autotiles = ds_list_create();
// also this is going to be really treated like an array, but it's going to be implemented
// as a list so that it can be swapped into things with the se and mesh and whatever lists
repeat (AUTOTILE_AVAILABLE_MAX) {
    ds_list_add(all_graphic_autotiles, noone);
}
all_graphic_autotiles[| 0] = [sprite_add(PATH_GRAPHICS + "b_at_default_grass_0.png", 0, false, false, 0, 0), "<default>", false, "", 1, 3];

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
all_graphic_ui_texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_width(surface), false, false, 0, 0);;
surface_free(surface);

#region autotile map
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
#endregion

ds_list_add(all_graphic_tilesets, tileset_create(PATH_GRAPHICS + "b_tileset_overworld_0.png", [
    // this is somewhat hard-coded;
    // the zeroth available tileset is automatically default_grass
    0, noone, noone, noone, noone, noone, noone, noone,
    noone, noone, noone, noone, noone, noone, noone, noone
]));

all_events = ds_list_create();
all_event_custom = ds_list_create();
all_event_prefabs = ds_list_create();
active_event = event_create("DefaultEvent");
event_node_info = noone;
ds_list_add(all_events, active_event);

switches = ds_list_create();         // [name, value]
variables = ds_list_create();        // [name, value]
for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    ds_list_add(switches, ["Switch" + string(i), false]);
    ds_list_add(variables, ["Variable" + string(i), 0]);
}

all_event_triggers = ds_list_create();
ds_list_add(all_event_triggers, "Action Button", "Player Touch", "Event Touch", "Autorun");

#region prefab events
event_prefab[EventNodeTypes.INPUT_TEXT] = create_event_node_basic("InputText", [
    ["Help Text", DataTypes.STRING, 0, 1, false, "For example, \"Please enter your name\""],
    ["Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_input_type_data, event_prefab_render_variable_name],
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

// stuff i couldn't do in game maker so i did in c++ instead
ds_stuff_init();

// camera setup may depend on some stuff existing in here, which
// is bad design, but this is just supposed to work and doesnt have
// to be well-designed
c_init();
c_world_create();

// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
instance_create_depth(0, 0, 0, Controller);
// various types of editors
terrain = instance_create_depth(0, 0, 0, EditorModeTerrain);
instance_deactivate_object(terrain);

// this is order-dependant, and it SUCKS, so re-write it later when there's time
all_maps = ds_list_create();
active_map = instance_create_depth(0, 0, 0, DataMapContainer);
active_map.contents = instance_create_depth(0, 0, 0, MapContents);
ds_grid_resize(active_map.contents.map_grid, active_map.xx, active_map.yy);
map_fill_grid(active_map.contents.map_grid, active_map.zz);
// this depends on activemap
instance_create_depth(0, 0, 0, Camera);

#region collision stuff plus basic shapes
c_transform_scaling(tile_width, tile_height, tile_depth);
c_shape_tile = c_shape_create();
c_shape_begin_trimesh();
c_shape_load_trimesh("data\\basic\\ctile.d3d");
c_shape_end_trimesh(c_shape_tile);
c_shape_block = c_shape_create();
c_shape_begin_trimesh();
c_shape_load_trimesh("data\\basic\\ccube.d3d");
c_shape_end_trimesh(c_shape_block);
c_transform_identity();

basic_cage = import_d3d("data\\basic\\cage.d3d", false);

water_tile_size = 0xffff;
water_reptition = 256;

mesh_water_base = vertex_create_buffer();
mesh_water_bright = vertex_create_buffer();

vertex_begin(mesh_water_base, Camera.vertex_format_basic);
vertex_begin(mesh_water_bright, Camera.vertex_format_basic);

terrain_create_square(mesh_water_base, -water_tile_size / 2, -water_tile_size / 2, water_tile_size, 0, 0, water_tile_size / water_reptition, 0, -32, -32, -32, -32);
terrain_create_square(mesh_water_bright, -water_tile_size / 2, -water_tile_size / 2, water_tile_size, 0, 0, water_tile_size / water_reptition, 0, -16, -16, -16, -16);

vertex_end(mesh_water_base);
vertex_end(mesh_water_bright);
#endregion

all_bgm = ds_list_create();
all_se = ds_list_create();
all_meshes = ds_list_create();

all_animations = ds_list_create();

all_game_constants = ds_list_create();

FMODGMS_Sys_Create();
FMODGMS_Sys_Initialize(32);

fmod_channel = FMODGMS_Chan_CreateChannel();
FMODGMS_Chan_Set_Frequency(fmod_channel, AUDIO_BASE_FREQUENCY);
fmod_sound = noone;
fmod_playing = false;
fmod_paused = false;

all_data = ds_list_create();
original_data = noone;            // when you're modifying the data types and want to stash the old ones

error_log_messages = ds_list_create();

// help contents

enum HelpPages {
    OVERVIEW, WHATSNEW, GETTINGSTARTED, SYSTEMREQUIREMENTS,
    EDITORCOMPONENTS, TABS, MENUS,
    TAB_GENERAL, TAB_ENTITY, TAB_TILE, TAB_MESH, TAB_PAWN, TAB_EFFECT, TAB_EVENT,
    TAB_MESH_EDITOR, TAB_TILE_EDITOR, TAB_AUTOTILE_EDITOR,
    AUTOTILES,
}

help_pages = [
    "overview", "whatsnew", "gettingstarted", "systemrequirements",
    "editorcomponents", "tabs", "menus",
    "general", "entityinstances", "tileinstances", "meshinstances", "pawninstances", "effectinstances", "eventinstances",
    "mesheditor", "tileeditor", "autotileeditor",
    "autotiles",
];

color_lookup = [c_red, c_green, c_blue, c_orange, c_aqua, c_fuchsia, c_purple, c_teal];

// global game settings

game_starting_map = active_map.GUID;
game_starting_x = 0;
game_starting_y = 0;
game_starting_z = 0;
game_starting_direction = 0;
game_player_grid = true;
game_battle_style = BattleStyles.TEAM_BASED;

direction_lookup = [270, 180, 0, 90];

// save settings

save_name = "game";

if (file_exists("projects.json")) {
	all_projects = json_decode(file_get_contents("projects.json"));
} else {
	all_projects = ds_map_create();
	ds_map_add_list(all_projects, "projects", ds_list_create());
}

#region user settings
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
    ds_map_add_map(settings, "Map", settings_map);
    ds_map_add_map(settings, "Animation", settings_animation);
    ds_map_add_map(settings, "Terrain", settings_terrain);
    ds_map_add_map(settings, "Event", settings_event);
    ds_map_add_map(settings, "Data", settings_data);
    ds_map_add_map(settings, "Config", settings_config);
    ds_map_add_map(settings, "Location", settings_location);
    ds_map_add_map(settings, "Selection", settings_config);
    ds_map_add_map(settings, "View", settings_location);
}

setting_color = setting_get("Config", "color", c_green);                  // BGR
setting_bezier_precision = setting_get("Config", "bezier", 6);            // preferably keep this between like 4 and 16ish?
setting_backups = setting_get("Config", "backups", 2);                    // 0 (none) through 9 (why would you keep that many backups?)
setting_autosave = setting_get("Config", "autosave", true);               // bool
setting_npc_animate_rate = setting_get("Config", "npc-speed", 4);         // bool
setting_code_extension = setting_get("Config", "code-ext", 0);            // 0 = txt, 1 = lua
setting_normal_threshold = setting_get("Config", "normal-threshold", 30); // degrees

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

setting_code_extension_map = [".txt", ".lua"];

setting_hide_warnings = ds_map_create();
#endregion

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

// hacky workaround
maps_included = false;

/*
 * Editor modes
 */

switch (EDITOR_BASE_MODE) {
    case EditorModes.EDITOR_HEIGHTMAP: editor_mode_heightmap(); break;
    default: editor_mode_3d(); break;
}

mode = EDITOR_BASE_MODE;

// if / when you add more of these remember to also add another series of Draw
// instructions to Camera.Draw
enum EditorModes {
    EDITOR_3D,
    EDITOR_EVENT,
    EDITOR_DATA,
    EDITOR_ANIMATION,
    EDITOR_HEIGHTMAP,
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

// this depends on activemap existing
graphics_create_grids();
uivc_select_autotile_refresh();