/// @description setup

#region basic setup

randomize();

// local storage folders
if (!directory_exists(PATH_TEMP)) directory_create(PATH_TEMP);
if (!directory_exists(PATH_AUDIO)) directory_create(PATH_AUDIO);
if (!directory_exists(PATH_PROJECTS)) directory_create(PATH_PROJECTS);

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
    SPART,
    DOODLE,
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

is_quitting = false;
files_dropped = [];

#endregion

#region user settings
save_name = "game";

try {
    all_projects = json_parse(file_get_contents("projects.json"));
} catch (e) {
    all_projects = { projects: [] };
}

alarm[ALARM_SETTINGS_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;
#endregion

#region initialize standalone systems

scribble_font_set_default("FDefault");

//dotdae_init();
wtf("re-add the dotdae thing eventually");
wtf("re-add nik's version of fmod audio eventually");
#endregion

#region editor modes (and similar things)
// at some point there shouldn't necessarily need to be an active
// map in existence for this to work, but for now there does
instance_create_depth(0, 0, 0, Controller);
all_modes = ds_list_create();
graphics = new EditorGraphics();
graphics.Init();
// various types of editors
map = instance_create_depth(0, 0, 0, EditorModeMap);
data = instance_create_depth(0, 0, 0, EditorModeData);
event = instance_create_depth(0, 0, 0, EditorModeEvent);
animation = instance_create_depth(0, 0, 0, EditorModeAnimation);
terrain = instance_create_depth(0, 0, 0, EditorModeTerrain);
mesh_ed = instance_create_depth(0, 0, 0, EditorModeMeshes);
spart = instance_create_depth(0, 0, 0, EditorModeSpart);
doodle = instance_create_depth(0, 0, 0, EditorModeDoodle);
text = new EditorModeText();
menu = RIBBON_MENU();

instance_deactivate_object(EditorMode);

self.graphics.RecreateGrids();
instance_deactivate_object(UIThing);
#endregion

#region stuff related to garbage collection
stuff_to_destroy = ds_queue_create();
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

default_pawn = new DataImage("Default Pawn");
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

tileset_create(PATH_GRAPHICS + DEFAULT_TILESET).name = "Default";
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

var data_type_class = function(id, name, default_value, buffer_type) constructor {
    self.id = id;
    self.name = name;
    self.default_value = default_value;
    self.buffer_type = buffer_type;
}

data_type_meta = [
    new data_type_class(00, "Integer",          0,          buffer_s32),
    new data_type_class(01, "Enum",             NULL,       buffer_datatype),
    new data_type_class(02, "Float",            0,          buffer_f32),
    new data_type_class(03, "String",           "",         buffer_string),
    new data_type_class(04, "Boolean",          false,      buffer_u8),
    
    new data_type_class(05, "Data",             NULL,       buffer_datatype),
    new data_type_class(06, "Code",             "",         buffer_string),
    new data_type_class(07, "Color",            0x000000,   buffer_u32),
    new data_type_class(08, "Mesh",             NULL,       buffer_datatype),
    new data_type_class(09, "Image: Texture",   NULL,       buffer_datatype),
    
    new data_type_class(10, "Tile",             NULL,       buffer_datatype),
    new data_type_class(11, "Image: Autotile",  NULL,       buffer_datatype),
    new data_type_class(12, "Audio: BGM",       NULL,       buffer_datatype),
    new data_type_class(13, "Audio: SE",        NULL,       buffer_datatype),
    new data_type_class(14, "Animation",        NULL,       buffer_datatype),
    
    new data_type_class(15, "Entity",           NULL,       buffer_datatype),
    new data_type_class(16, "Map",              NULL,       buffer_datatype),
    new data_type_class(17, "Image: Battler",   NULL,       buffer_datatype),
    new data_type_class(18, "Image: Overworld", NULL,       buffer_datatype),
    new data_type_class(19, "Image: Particle",  NULL,       buffer_datatype),
    
    new data_type_class(20, "Image: UI",        NULL,       buffer_datatype),
    new data_type_class(21, "Image: Misc",      NULL,       buffer_datatype),
    new data_type_class(22, "Event",            NULL,       buffer_datatype),
    new data_type_class(23, "Image: SKybox",    NULL,       buffer_datatype),
    new data_type_class(24, "Mesh Autotile",    NULL,       buffer_datatype),
    
    new data_type_class(25, "Asset Flag",       0,          buffer_flag),
];

/*
 * if you want to add a new data type, you need to:
 *  0. add it to the list here
 *           - type enum
 *           - default value
 *  1. add it to the following enums, if it's a serialized field:
 *           - SerializeThings
 *           - GameDataCategories
 *           - entry in dialog_create_settings_data_asset_files (with color)
 *  2. case in omu_data_list_add
 *  3. case in uivc_list_data_list_select
 *  4. case in draw_event_node
 *          - in four different switch statements (can that be simplified?)
 *  5. case in ui_init_game_data_activate (the big one)
 *  6. case in ui_init_game_data_refresh - in two different switch statements
 *  7. case in dialog_create_data_instance_property_list - in two different switch statemetns
 *  9. case in serialize_save_data_instances
 *          and the equivalent in the game
 *  10. case in serialize_save_events
 *          and the equivalent in the game
 *  11. text in the lists in dialog_create_select_data_types_ext (and the color, if applicable)
 *  12. case in draw_active_event
 *  13. case in uimu_data_add_data
 *  14. case in dialog_entity_data_enable_by_type
 *  15. case in serialize_save_entity
 *          and the equivalent in the game
 *  16. case in serialize_save_map_contents_meta
 *          and the equivalent in the game
 *  17. Stuff.Create - game data location and game data save scripts
 *  18. enum DataVersions - you most likely will need a new data version to handle the new data
 *  19. loading data in the game - read the data out
 */
#endregion

#region status messages
status_messages = [];
AddStatusMessage = function(text) {
    static statusMessage = function(text) constructor {
        self.text = text;
        self.duration = 15;
        self.x = 32;
        self.y = 48;
        
        static Update = function(target_y) {
            self.y = lerp(self.y, target_y, 0.1);
            self.duration -= Stuff.dt;
            return self.duration > 0;
        };
        
        static Render = function() {
            scribble(self.text)
                .blend(c_white, min(1, self.duration))
                .align(fa_left, fa_top)
                .wrap(window_get_width() - 64, 32)
                .draw(self.x, self.y);
        };
    };
    
    array_insert(Stuff.status_messages, 0, new statusMessage(text));
}
#endregion

// default editor mode
switch (EDITOR_FORCE_SINGLE_MODE ? EDITOR_BASE_MODE : Settings.config.mode) {
    case ModeIDs.MAP: editor_mode_3d(); break;
    case ModeIDs.EVENT: editor_mode_event(); break;
    case ModeIDs.DATA: editor_mode_data(); break;
    case ModeIDs.ANIMATION: editor_mode_animation(); break;
    case ModeIDs.TERRAIN: editor_mode_heightmap(); break;
    case ModeIDs.SPART: editor_mode_spart(); break;
    case ModeIDs.DOODLE: editor_mode_doodle(); break;
    case ModeIDs.MESH: editor_mode_meshes(); break;
    case ModeIDs.TEXT: editor_mode_text(); break;
}

if (PROJECT_MENU_ENABLED) {
    dialog_create_project_list(noone);
}