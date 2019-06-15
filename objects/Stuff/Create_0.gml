/// @description setup

#region setup
enum SerializeThings {
    ERROR                   =$00000000,
    // basic stuff
    MESHES_META             =$00000001,
    MESHES_REF              =$00000002,
    MESHES                  =$00000003,
    TILESET_META            =$00000004,
    TILESET_BASE            =$00000005,
    TILESET_AUTO            =$00000006,
    TILESET_ALL             =$00000007,
    PARTICLES               =$00000008,
    NPCS                    =$00000009,
    NPCS_FULL               =$0000000A,
    FOLLOWERS               =$0000000B,
    FOLLOWERS_FULL          =$0000000C,
    MISC_GRAPHICS           =$0000000D,
    MISC_GRAPHICS_FULL      =$0000000E,
    UI_GRAPHICS             =$0000000F,
    UI_GRAPHICS_FULL        =$00000010,
    GLOBAL_GRAPHICS         =$00000011,
    AUDIO_SE                =$00000012,
    AUDIO_SE_FULL           =$00000013,
    AUDIO_BGM               =$00000014,
    MAP_BATCH               =$00000015,
    MAP_DYNAMIC             =$00000016,
    EVENTS                  =$00000017,
    AUTOTILES_META          =$00000018,
    AUTOTILES_FULL          =$00000019,
    MAP_META                =$0000001A,
    DATADATA                =$0000001B,
    EVENT_CUSTOM            =$0000001C,
    EVENT_TEMPLATE          =$0000001D,
    // game data
    DATA_ERROR              =$00000100,
    DATA_INSTANCES          =$00000101,
    // misc
    MISC_ERROR              =$00001000,
    MISC_MAP_META           =$00001001,
    MISC_GLOBAL             =$00001002,
    MISC_UI                 =$00001003,
    // the last one i think
    END_OF_FILE             =$00002000,
}

enum ETypes {
    ENTITY,
    ENTITY_TILE,
    ENTITY_TILE_AUTO,
    ENTITY_MESH,
    ENTITY_PAWN,
    ENTITY_EFFECT,
    ENTITY_EVENT
}

enum ETypeFlags {
    ENTITY                  =1<<0,
    ENTITY_TILE             =1<<1,
    ENTITY_TILE_AUTO        =1<<2,
    ENTITY_MESH             =1<<3,
    ENTITY_PAWN             =1<<4,
    ENTITY_EFFECT           =1<<5,
    ENTITY_EVENT            =1<<6,
}

etype_objects=[Entity,
    EntityTile,
    EntityAutoTile,
    EntityMesh,
    EntityPawn,
    EntityEffect,
    EntityEvent];
#endregion

alarm[0] = 1200;

/// this is basically World/Settings

randomize();

if (DEBUG) {
    show_debug_overlay(true);
}

// persistent stuff
dt = 0;
time = 0;
time_int = 0;

all_guids = ds_map_create();
all_internal_names = ds_map_create();

tf = ["False", "True"];

// local storage folders

if (!directory_exists(PATH_BACKUP_DATA)) {
    directory_create(PATH_BACKUP_DATA);
}

if (!directory_exists(PATH_BACKUP_MAP)) {
    directory_create(PATH_BACKUP_MAP);
}

if (!directory_exists(PATH_VRA)) {
    directory_create(PATH_VRA);
}

if (!directory_exists(PATH_RESOURCES)) {
    directory_create(PATH_RESOURCES);
}

if (!directory_exists(PATH_TEMP_CODE)) {
    directory_create(PATH_TEMP_CODE);
}

// these are constants in DDD.gmx but we're allowed to change them here
tile_width = 32;
tile_height = 32;
tile_depth = 32;

// uv size, not 3D size
tile_size = 32;

dimensions = Dimensions.THREED;

// ALL DATA THAT DOES NOT DEPEND ON ANYTHING ELSE!
// (except the other data defined in this section)

// This will cause a problem with texture pages later. They ought to be batched properly - and also,
// loaded from files

if (file_exists(PATH_PERMANENT + "b_chr_default.png")) {
    spr_character_default = sprite_add(PATH_PERMANENT + "b_chr_default.png", 0, false, false, 0, 0);
} else {
    spr_character_default = sprite_add(PATH_DUMMY + "b_chr_dummy.png", 0, false, false, 0, 0);
}

// this sounds like a reasonable limit, it's not based on anything though
available_autotiles = array_create(AUTOTILE_AVAILABLE_MAX);
array_clear(available_autotiles, noone);

if (file_exists(PATH_PERMANENT + "b_at_default_grass_0.png")) {
    var spr = sprite_add(PATH_PERMANENT + "b_at_default_grass_0.png", 0, false, false, 0, 0);
} else {
    var spr = sprite_add(PATH_DUMMY + "b_at_dummy_grass.png", 0, false, false, 0, 0);
}
available_autotiles[0] = [spr, "<default>", false, "", 1, 3];

autotile_hashes=array_create(256);
array_clear(autotile_hashes, AutotileSegments.CENTER);
autotile_hashes[11] = AutotileSegments.LOWER_RIGHT;
autotile_hashes[22] = AutotileSegments.LOWER_LEFT;
autotile_hashes[31] = AutotileSegments.LOWER;
autotile_hashes[104] = AutotileSegments.UPPER_RIGHT;
autotile_hashes[107] = AutotileSegments.RIGHT;
autotile_hashes[165] = AutotileSegments.INVERSE;
autotile_hashes[208] = AutotileSegments.UPPER_LEFT;
autotile_hashes[214] = AutotileSegments.LEFT;
autotile_hashes[248] = AutotileSegments.UPPER;
// this one's the default but
//autotile_hashes[255]=AutotileSegments.CENTER;

all_tilesets = ds_list_create();
if (file_exists(PATH_PERMANENT + "b_tileset_overworld_0.png")) {
    var filename = PATH_PERMANENT + "b_tileset_overworld_0.png";
} else {
    var filename = PATH_DUMMY + "b_tileset_dummy_overworld.png";
}

ds_list_add(all_tilesets, tileset_create(filename,
    // this is somewhat hard-coded;
    // the zeroth available tileset is automatically default_grass
    [0, noone, noone, noone, noone, noone, noone, noone,
        noone, noone, noone, noone, noone, noone, noone, noone]));

all_events = ds_list_create();
all_event_custom = ds_list_create();
all_event_templates = ds_list_create();
active_event = event_create("DefaultEvent");
event_node_info = noone;
ds_list_add(all_events, active_event);

// stuff i couldn't do in game maker so i did in c++ instead
ds_stuff_init();

// camera setup may depend on some stuff existing in here, which
// is bad design, but this is just supposed to work and doesnt have
// to be well-designed
c_init();
c_world_create();

c_shape_tile = c_shape_create();
c_shape_begin_trimesh();
c_shape_add_triangle(0, 0, 0, tile_width, 0, 0, tile_width, tile_height, 0);
c_shape_add_triangle(tile_width, tile_height, 0, 0, tile_height, 0, 0, 0, 0);
c_shape_end_trimesh(c_shape_tile);
c_shape_block = c_shape_create();
c_shape_begin_trimesh();
// bottom
c_shape_add_triangle(0, 0, 0, tile_width, 0, 0, tile_width, tile_height, 0);
c_shape_add_triangle(tile_width, tile_height, 0, 0, tile_height, 0, 0, 0, 0);
// top
c_shape_add_triangle(0, 0, tile_depth, tile_width, 0, 0, tile_width, tile_height, tile_depth);
c_shape_add_triangle(tile_width, tile_height, tile_depth, 0, tile_height, 0, 0, 0, tile_depth);
// left
c_shape_add_triangle(0, 0, 0, 0, 0, tile_depth, 0, tile_height, tile_depth);
c_shape_add_triangle(0, tile_height, tile_depth, 0, tile_height, 0, 0, 0, 0);
// right
c_shape_add_triangle(tile_width, 0, 0, tile_width, 0, tile_depth, tile_width, tile_height, tile_depth);
c_shape_add_triangle(tile_width, tile_height, tile_depth, tile_width, tile_height, 0, tile_width, 0, 0);
// front
c_shape_add_triangle(0, 0, 0, 0, 0, tile_depth, tile_width, 0, tile_height);
c_shape_add_triangle(tile_width, 0, tile_height, tile_width, 0, 0, 0, 0, 0);
// back
c_shape_add_triangle(0, tile_height, 0, 0, tile_height, tile_depth, tile_width, tile_height, tile_height);
c_shape_add_triangle(tile_width, tile_height, tile_height, tile_width, tile_height, 0, 0, tile_height, 0);
c_shape_end_trimesh(c_shape_block);

// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
data_clear_map();
instantiate(Controller);

// this depends on activemap
instantiate(Camera);

// data that gets loaded: needs the camera (and vertex formats) to be
// defined before running
vra_data = ds_map_create();
vra_name = "";
all_mesh_names = ds_list_create();
data_load_vra();

// this depends on activemap existing
uivc_select_autotile_refresh(/*Camera.selection_fill_autotile*/);

enum AvailableAutotileProperties {
    PICTURE, NAME, DELETEABLE, FILENAME, FRAMES, WIDTH
    // sprite index, display name, true for built-in graphics and false otherwise, filename, animation frames, horizontal segments
}

// this gets populated when you save or load something, and also using a map to
// store maps is funny for some reason
all_maps = ds_map_create();

all_data = ds_list_create();
original_data = noone;            // when you're modifying the data types and want to stash the old ones

error_log_messages = ds_list_create();

// help contents

enum HelpPages {
    OVERVIEW, WHATSNEW, GETTINGSTARTED, SYSTEMREQUIREMENTS,
    EDITORCOMPONENTS, TABS, MENUS,
    TAB_GENERAL, TAB_ENTITY, TAB_TILE, TAB_MESH, TAB_MOB, TAB_EFFECT, TAB_EVENT,
    TAB_MESH_EDITOR, TAB_TILE_EDITOR, TAB_AUTOTILE_EDITOR,
    AUTOTILES,
}

help_pages = ["overview", "whatsnew", "gettingstarted", "systemrequirements",
    "editorcomponents", "tabs", "menus",
    "general", "entityinstances", "tileinstances", "meshinstances", "mobinstances", "effectinstances", "eventinstances",
    "mesheditor", "tileeditor", "autotileeditor",
    "autotiles",];

enum Dimensions {
    TWOD,
    THREED
}

enum BattleStyles {
    TEAM_BASED,             // everyone stays on their own side
    MELEE,                  // boundaries are not respected
}

color_lookup = [c_red, c_green, c_blue, c_orange, c_aqua, c_fuchsia, c_purple, c_teal];

// global game settings

game_map_starting = "";
game_player_grid = true;
game_battle_style = BattleStyles.TEAM_BASED;

// save settings

save_name_map = "";
save_name_data = "";

// user settings - dddd

setting_embed_tilesets = false;         // small number of large images
setting_embed_npcs = true;              // large number of small(ish) images
setting_embed_graphics = true;          // large number of images of varying sizes
setting_embed_meshes = false;           // already stored in vrax but okay
setting_embed_se = true;                // possibly large number of small sound effects
setting_compress = true;			    // this used to be a number but now it's just on/off

ini_open(DATA_INI);
setting_color = ini_read_real("config", "color", c_green);                  // BGR
setting_bezier_precision = ini_read_real("config", "bezier", 6);            // preferably keep this between like 4 and 16ish?
setting_backups = ini_read_real("config", "backups", 2);                    // 0 (none) through 9 (why would you keep that many backups)
setting_autosave = ini_read_real("config", "autosave", true);               // bool
setting_alphabetize_lists = ini_read_real("config", "alphabetize", true);   // bool
setting_alphabetize_npc_animate_rate = ini_read_real("config", "npc-speed", 4); // bool
setting_code_extension = ini_read_real("config", "code-ext", 0);            // 0 = txt, 1 = lua

setting_code_extension_map = [".txt", ".lua"];
ini_close();

// todo: load configuration settings

// the autosave/load is nice, BUT it will make the game break if there's an error
// in either of them. so either do a LOT of validation or have a way to clear the
// autosaves if problems happen.

if (setting_autosave && file_exists("auto" + EXPORT_EXTENSION_DATA)) {
    var tdata = save_name_data;
    serialize_load("auto" + EXPORT_EXTENSION_DATA);
    save_name_data = tdata;
    if (file_exists("auto" + EXPORT_EXTENSION_MAP)) {
        // no need to store the map name in a variable since that's set based
        // on the internal name
        serialize_load("auto" + EXPORT_EXTENSION_MAP);
    }
}