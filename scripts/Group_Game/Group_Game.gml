#macro Game global.__game

var file_default = new DataFile("data", false, true);
var file_asset = new DataFile("assets", false, false);
var file_terrain = new DataFile("terrain", true, false);

Game = {
    project: {
        notes: "",
        summary: "Write a short summary in Global Game Settings",
        author: "Who made this?",
        id: string_hex(irandom(0xffffffff), 8),
    },
    
    switches: array_create(BASE_GAME_VARIABLES),
    variables: array_create(BASE_GAME_VARIABLES),
    
    event_triggers: array_create(FLAG_COUNT, ""),
    asset_flags: array_create(FLAG_COUNT, ""),
    constants: [],
    
    start: {
        x: 0,
        y: 0,
        z: 0,
        direction: 0,
        map: NULL,
        title: NULL,
    },
    
    grid: {
        snap: true,
        chunk_size: 32,
    },
    lighting: {
        ambient: c_white,
    },
    screen: {
        width: -1,
        height: -1,
    },
    export: {
        files: [file_default, file_asset, file_terrain],
        locations: [],
    },
};

Game.export.locations[GameDataCategories.TILE_ANIMATIONS] = file_asset;
Game.export.locations[GameDataCategories.TILESETS] = file_asset;
Game.export.locations[GameDataCategories.BATTLERS] = file_asset;
Game.export.locations[GameDataCategories.OVERWORLDS] = file_asset;
Game.export.locations[GameDataCategories.PARTICLES] = file_asset;
Game.export.locations[GameDataCategories.UI] = file_asset;
Game.export.locations[GameDataCategories.SKYBOX] = file_asset;
Game.export.locations[GameDataCategories.MISC] = file_asset;
Game.export.locations[GameDataCategories.BGM] = file_asset;
Game.export.locations[GameDataCategories.SE] = file_asset;
Game.export.locations[GameDataCategories.MESH] = file_asset;
Game.export.locations[GameDataCategories.MESH_AUTOTILES] = file_asset;
Game.export.locations[GameDataCategories.MAP] = file_default;
Game.export.locations[GameDataCategories.GLOBAL] = file_default;
Game.export.locations[GameDataCategories.EVENTS]  = file_default;
Game.export.locations[GameDataCategories.DATADATA] = file_default;
Game.export.locations[GameDataCategories.DATA_INST] = file_default;
Game.export.locations[GameDataCategories.ANIMATIONS] = file_default;
Game.export.locations[GameDataCategories.TERRAIN] = file_terrain;
Game.export.locations[GameDataCategories.LANGUAGE_TEXT] = file_default;

for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    Game.switches[i] = new DataValue("Switch" + string(i));
    Game.variables[i] = new DataValue("Variable" + string(i));
}

Game.event_triggers[0] = "Action Button";
Game.event_triggers[1] = "Player Touch";
Game.event_triggers[2] = "Event Touch";
Game.event_triggers[3] = "Autorun";

Game.asset_flags[0] = "CollidePlayer";
Game.asset_flags[1] = "CollideNPC";
Game.asset_flags[2] = "Danger";
Game.asset_flags[3] = "Safe";
Game.asset_flags[4] = "Water";