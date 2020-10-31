// this defines a few global things, like names associated with each enum;
// this is generally not a great practice and you should do it sparingly
enum SerializeThings {
    ERROR                   = 0x00000000,
    // basic stuff
    MAPS                    = 0x00000001,
    CONSTANTS               = 0x00000002,
    MESHES                  = 0x00000003,
    ANIMATIONS              = 0x00000004,
    TERRAIN                 = 0x00000005,
    IMAGE_SKYBOX            = 0x00000006,
    IMAGE_TILESET           = 0x00000007,
    IMAGE_PARTICLES         = 0x00000008, //+
    IMAGE_OVERWORLD         = 0x00000009, //+
    // 0a
    IMAGE_BATTLERS          = 0x0000000B, //+
    // 0c
    IMAGE_MISC              = 0x0000000D, //+
    // 0e
    IMAGE_UI                = 0x0000000F, //+
    // 10
    GLOBAL_GRAPHICS         = 0x00000011,
    AUDIO_SE                = 0x00000012,
    MAP_ZONES               = 0x00000013,
    AUDIO_BGM               = 0x00000014,
    MAP_BATCH               = 0x00000015,
    MAP_DYNAMIC             = 0x00000016,
    EVENTS                  = 0x00000017,
    // 18
    IMAGE_TILE_ANIMATION    = 0x00000019,
    MAP_META                = 0x0000001A,
    DATADATA                = 0x0000001B,
    EVENT_CUSTOM            = 0x0000001C,
    EVENT_PREFAB            = 0x0000001D,
    MAP_STATIC_TERRAIN      = 0x0000001E,
    
    // game data
    DATA_ERROR              = 0x00000100,
    DATA_INSTANCES          = 0x00000101,
    
    // misc
    MISC_ERROR              = 0x00001000,
    GLOBAL_METADATA         = 0x00001001,
    MISC_GLOBAL             = 0x00001002,
    MISC_UI                 = 0x00001003,
    
    // the last one i think
    END_OF_FILE             = 0x00002000,
}

// Note: event entites have been removed, owing to the fact that every entity
// can carry event information now
enum ETypes {
    ENTITY,
    ENTITY_TILE,
    ENTITY_TILE_ANIMATED,
    ENTITY_MESH,
    ENTITY_PAWN,
    ENTITY_EFFECT,
    ENTITY_MESH_AUTO,
}

global.etype_objects = [
    Entity,
    EntityTile,
    EntityTileAnimated,
    EntityMesh,
    EntityPawn,
    EntityEffect,
    EntityMeshAutotile,
];

// each type includes the parent objects, which includes Entity for everything and
// some others for objects that are derived from something else
enum ETypeFlags {
    ENTITY_TILE             = 0x002,
    ENTITY_TILE_ANIMATED    = 0x004 | ETypeFlags.ENTITY_TILE,
    ENTITY_MESH             = 0x008,
    ENTITY_PAWN             = 0x010,
    ENTITY_EFFECT           = 0x020,
    ENTITY_MESH_AUTO        = 0x040 | ETypeFlags.ENTITY_MESH,
    // every mask
    ENTITY_ANY              = 0xffffffff,
}

enum AnimationTweens {
    IGNORE, NONE, LINEAR,
    EASE_QUAD_I, EASE_QUAD_O, EASE_QUAD_IO,
    EASE_CUBE_I, EASE_CUBE_O, EASE_CUBE_IO,
    EASE_QUART_I, EASE_QUART_O, EASE_QUART_IO,
    EASE_QUINT_I, EASE_QUINT_O, EASE_QUINT_IO,
    EASE_SINE_I, EASE_SINE_O, EASE_SINE_IO,
    EASE_EXP_I, EASE_EXP_O, EASE_EXP_IO,
    EASE_CIRC_I, EASE_CIRC_O, EASE_CIRC_IO,
}

global.animation_tween_names = ds_list_create();
ds_list_add(global.animation_tween_names,
    "Ignore", "None", "Linear",
    "Quadratic In", "Quadratic Out", "Quadratic In / Out",
    "Cubic In", "Cubic Out", "Cubic In / Out",
    "Quartic In", "Quartic Out", "Quartic In / Out",
    "Quintic In", "Quintic Out", "Quintic In / Out",
    "Sinusoidal In", "Sinusoidal Out", "Sinusoidal In / Out",
    "Exponential In", "Exponential Out", "Exponential In / Out",
    "Circular In", "Circular Out", "Circular In / Out",
);

global.easing_equations = [
    ease_none, ease_none, ease_linear,
    ease_quad_i, ease_quad_o, ease_quad_io,
    ease_cube_i, ease_cube_o, ease_cube_io,
    ease_quart_i, ease_quart_o, ease_quart_io,
    ease_quint_i, ease_quint_o, ease_quint_io,
    ease_sine_i, ease_sine_o, ease_sine_io,
    ease_exp_i, ease_exp_o, ease_exp_io,
    ease_circ_i, ease_circ_o, ease_circ_io,
];

enum Dimensions {
    TWOD,
    THREED
}

enum BattleStyles {
    TEAM_BASED,             // everyone stays on their own side
    GRID_BASED,             // boundaries are not respected
    ACTION,                 // z*lda
}

enum MapZoneTypes {
    CAMERA,                 // 0x0000ff (blue)
    LIGHT,                  // 0xffff00 (yellow)
    FLAG,                   // 0x00ff00 (green)
}

global.map_zone_type_objects = [
    DataCameraZone,
    DataLightZone,
    DataFlagZone,
];

// this can also be used for anything else that needs eight directions
// which may occasionally be combined
enum ATMask {
    NONE        = 0x0000,
    NORTHWEST   = 0x0001,
    NORTH       = 0x0002,
    NORTHEAST   = 0x0004,
    WEST        = 0x0008,
    EAST        = 0x0010,
    SOUTHWEST   = 0x0020,
    SOUTH       = 0x0040,
    SOUTHEAST   = 0x0080,
}

// there are other ways i'd prefer to do this but i also would kinda like to not make
// a second cardinal directions enum
global.at_mask_values = [ATMask.NONE, ATMask.NORTHWEST, ATMask.NORTH, ATMask.NORTHEAST, ATMask.WEST, ATMask.EAST, ATMask.SOUTHWEST, ATMask.SOUTH, ATMask.SOUTHEAST];
global.at_mask_lookup = ds_map_create();
global.at_mask_lookup[? ATMask.NONE] = 0;
global.at_mask_lookup[? ATMask.NORTHWEST] = 1;
global.at_mask_lookup[? ATMask.NORTH] = 2;
global.at_mask_lookup[? ATMask.NORTHEAST] = 3;
global.at_mask_lookup[? ATMask.WEST] = 4;
global.at_mask_lookup[? ATMask.EAST] = 5;
global.at_mask_lookup[? ATMask.SOUTHWEST] = 6;
global.at_mask_lookup[? ATMask.SOUTH] = 7;
global.at_mask_lookup[? ATMask.SOUTHEAST] = 8;

global.at_map = ds_map_create();
global.at_map[? 2] = 1;
global.at_map[? 8] = 2;
global.at_map[? 10] = 3;
global.at_map[? 11] = 4;
global.at_map[? 16] = 5;
global.at_map[? 18] = 6;
global.at_map[? 22] = 7;
global.at_map[? 24] = 8;
global.at_map[? 26] = 9;
global.at_map[? 27] = 10;
global.at_map[? 30] = 11;
global.at_map[? 31] = 12;
global.at_map[? 64] = 13;
global.at_map[? 66] = 14;
global.at_map[? 72] = 15;
global.at_map[? 74] = 16;
global.at_map[? 75] = 17;
global.at_map[? 80] = 18;
global.at_map[? 82] = 19;
global.at_map[? 86] = 20;
global.at_map[? 88] = 21;
global.at_map[? 90] = 22;
global.at_map[? 91] = 23;
global.at_map[? 94] = 24;
global.at_map[? 95] = 25;
global.at_map[? 104] = 26;
global.at_map[? 106] = 27;
global.at_map[? 107] = 28;
global.at_map[? 120] = 29;
global.at_map[? 122] = 30;
global.at_map[? 123] = 31;
global.at_map[? 126] = 32;
global.at_map[? 127] = 33;
global.at_map[? 208] = 34;
global.at_map[? 210] = 35;
global.at_map[? 214] = 36;
global.at_map[? 216] = 37;
global.at_map[? 218] = 38;
global.at_map[? 219] = 39;
global.at_map[? 222] = 40;
global.at_map[? 223] = 41;
global.at_map[? 248] = 42;
global.at_map[? 250] = 43;
global.at_map[? 251] = 44;
global.at_map[? 254] = 45;
global.at_map[? 255] = 46;
global.at_map[? 0] = 47;

enum LightTypes {
    NONE,
    DIRECTIONAL,
    POINT,
    SPOT,
}

enum ParticleTypes {
    NONE,
}

enum AudioTypes {
    NONE,
}

enum CollisionMasks {
    NONE                    = 0x0000,
    MAIN                    = 0x0001,
    SURFACE                 = 0x0002,
    AXES                    = 0x0004,
}

enum CollisionSpecialValues {
    NONE,
    TRANSLATE_X,
    TRANSLATE_Y,
    TRANSLATE_Z,
}

enum AnimationEndActions {
    STOP,
    LOOP,
    REVERSE,
    END,
}

global.animation_end_action_names = [
    "Stop",
    "Loop",
    "Reverse",
    "End"
];