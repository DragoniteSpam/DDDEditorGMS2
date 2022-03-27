enum ETypes {
    ENTITY,
    ENTITY_TILE,
    ENTITY_TILE_ANIMATED,
    ENTITY_MESH,
    ENTITY_PAWN,
    ENTITY_EFFECT,
    ENTITY_MESH_AUTO,
}

// each type includes the parent objects, which includes Entity for everything and
// some others for objects that are derived from something else
enum ETypeFlags {
    ENTITY                  = 0x001,
    ENTITY_TILE             = 0x002 | ETypeFlags.ENTITY,
    ENTITY_TILE_ANIMATED    = 0x004 | ETypeFlags.ENTITY_TILE,
    ENTITY_MESH             = 0x008 | ETypeFlags.ENTITY,
    ENTITY_PAWN             = 0x010 | ETypeFlags.ENTITY,
    ENTITY_EFFECT           = 0x020 | ETypeFlags.ENTITY,
    ENTITY_MESH_AUTO        = 0x040 | ETypeFlags.ENTITY_MESH,
    // every mask
    ENTITY_ANY              = 0xffffffff,
}

var etype = function(id, name, constructor, mask) constructor {
    self.id = id;
    self.name = name;
    self.constructor = constructor;
    self.mask = mask;
}

global.etype_meta = [
    new etype(ETypes.ENTITY,                    "Entity",               Entity,                 0),
    new etype(ETypes.ENTITY_TILE,               "EntityTile",           EntityTile,             ETypeFlags.ENTITY_TILE),
    new etype(ETypes.ENTITY_TILE_ANIMATED,      "EntityTileAnimated",   EntityTileAnimated,     ETypeFlags.ENTITY_TILE_ANIMATED),
    new etype(ETypes.ENTITY_MESH,               "EntityMesh",           EntityMesh,             ETypeFlags.ENTITY_MESH),
    new etype(ETypes.ENTITY_PAWN,               "EntityPawn",           EntityPawn,             ETypeFlags.ENTITY_PAWN),
    new etype(ETypes.ENTITY_EFFECT,             "EntityEffect",         EntityEffect,           ETypeFlags.ENTITY_EFFECT),
    new etype(ETypes.ENTITY_MESH_AUTO,          "EntityMeshAutotile",   EntityMeshAutotile,     ETypeFlags.ENTITY_MESH_AUTO),
];

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
    MapZoneCamera,
    MapZoneLight,
    MapZoneFlag,
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

global.at_map = { };
global.at_map[$ 2] = 1;
global.at_map[$ 8] = 2;
global.at_map[$ 10] = 3;
global.at_map[$ 11] = 4;
global.at_map[$ 16] = 5;
global.at_map[$ 18] = 6;
global.at_map[$ 22] = 7;
global.at_map[$ 24] = 8;
global.at_map[$ 26] = 9;
global.at_map[$ 27] = 10;
global.at_map[$ 30] = 11;
global.at_map[$ 31] = 12;
global.at_map[$ 64] = 13;
global.at_map[$ 66] = 14;
global.at_map[$ 72] = 15;
global.at_map[$ 74] = 16;
global.at_map[$ 75] = 17;
global.at_map[$ 80] = 18;
global.at_map[$ 82] = 19;
global.at_map[$ 86] = 20;
global.at_map[$ 88] = 21;
global.at_map[$ 90] = 22;
global.at_map[$ 91] = 23;
global.at_map[$ 94] = 24;
global.at_map[$ 95] = 25;
global.at_map[$ 104] = 26;
global.at_map[$ 106] = 27;
global.at_map[$ 107] = 28;
global.at_map[$ 120] = 29;
global.at_map[$ 122] = 30;
global.at_map[$ 123] = 31;
global.at_map[$ 126] = 32;
global.at_map[$ 127] = 33;
global.at_map[$ 208] = 34;
global.at_map[$ 210] = 35;
global.at_map[$ 214] = 36;
global.at_map[$ 216] = 37;
global.at_map[$ 218] = 38;
global.at_map[$ 219] = 39;
global.at_map[$ 222] = 40;
global.at_map[$ 223] = 41;
global.at_map[$ 248] = 42;
global.at_map[$ 250] = 43;
global.at_map[$ 251] = 44;
global.at_map[$ 254] = 45;
global.at_map[$ 255] = 46;
global.at_map[$ 0] = 47;

enum LightTypes {
    NONE,
    DIRECTIONAL,
    POINT,
    SPOT,
}

global.light_type_constructors = [
    undefined,
    ComponentDirectionalLight,
    ComponentPointLight,
    ComponentSpotLight,
];

enum CollisionMasks {
    NONE                    = 0x0000,
    MAIN                    = 0x0001,
    SURFACE                 = 0x0002,
    AXES                    = 0x0004,
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