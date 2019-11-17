enum SerializeThings {
    ERROR                   = 0x00000000,
    // basic stuff
    MAPS					= 0x00000001,
    CONSTANTS               = 0x00000002,
    MESHES                  = 0x00000003,
    ANIMATIONS              = 0x00000004,
    TERRAIN                 = 0x00000005,
    // 06
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
    // 13
    AUDIO_BGM               = 0x00000014,
    MAP_BATCH               = 0x00000015,
    MAP_DYNAMIC             = 0x00000016,
    EVENTS                  = 0x00000017,
    // 18
    IMAGE_AUTOTILES         = 0x00000019,
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
    ENTITY_TILE_AUTO,
    ENTITY_MESH,
    ENTITY_PAWN,
    ENTITY_EFFECT,
    ENTITY_EVENT,
    ENTITY_TERRAIN
}

enum ETypeFlags {
    ENTITY                  = 1 << 0,
    ENTITY_TILE             = 1 << 1,
    ENTITY_TILE_AUTO        = 1 << 2,
    ENTITY_MESH             = 1 << 3,
    ENTITY_PAWN             = 1 << 4,
    ENTITY_EFFECT           = 1 << 5,
    ENTITY_EVENT            = 1 << 6,
    ENTITY_TERRAIN          = 1 << 7,
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
    SCRIPT, AUDIO_CONTORLS, DEACTIVATE_EVENT, ADVANCED1, ADVANCED2, ADVANCED3, ADVANCED4, ADVANCED5, ADVANCED6, ADVANCED7,
    // i forgot to put this one with the other text nodes
    SHOW_CHOICES,
}

enum Dimensions {
    TWOD,
    THREED
}

enum BattleStyles {
    TEAM_BASED,             // everyone stays on their own side
    GRID_BASED,             // boundaries are not respected
}

enum TileSelectorDisplayMode {
    PASSAGE,
    PRIORITY,
    FLAGS,
    TAGS,
}

enum TileSelectorOnClick {
    SELECT,
    MODIFY,
}