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
    
    all_event_triggers: array_create(FLAG_COUNT, ""),
    all_asset_flags: array_create(FLAG_COUNT, ""),
    all_constants: [],
    
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
    asset_lists: [file_default, file_asset, file_terrain],
    data_location: [],
};

Game.data_location[GameDataCategories.TILE_ANIMATIONS] = file_asset;
Game.data_location[GameDataCategories.TILESETS] = file_asset;
Game.data_location[GameDataCategories.BATTLERS] = file_asset;
Game.data_location[GameDataCategories.OVERWORLDS] = file_asset;
Game.data_location[GameDataCategories.PARTICLES] = file_asset;
Game.data_location[GameDataCategories.UI] = file_asset;
Game.data_location[GameDataCategories.SKYBOX] = file_asset;
Game.data_location[GameDataCategories.MISC] = file_asset;
Game.data_location[GameDataCategories.BGM] = file_asset;
Game.data_location[GameDataCategories.SE] = file_asset;
Game.data_location[GameDataCategories.MESH] = file_asset;
Game.data_location[GameDataCategories.MESH_AUTOTILES] = file_asset;
Game.data_location[GameDataCategories.MAP] = file_default;
Game.data_location[GameDataCategories.GLOBAL] = file_default;
Game.data_location[GameDataCategories.EVENTS]  = file_default;
Game.data_location[GameDataCategories.DATADATA] = file_default;
Game.data_location[GameDataCategories.DATA_INST] = file_default;
Game.data_location[GameDataCategories.ANIMATIONS] = file_default;
Game.data_location[GameDataCategories.TERRAIN] = file_terrain;
Game.data_location[GameDataCategories.LANGUAGE_TEXT] = file_default;

for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    Game.switches[i] = new DataValue("Switch" + string(i));
    Game.variables[i] = new DataValue("Variable" + string(i));
}

Game.all_event_triggers[0] = "Action Button";
Game.all_event_triggers[1] = "Player Touch";
Game.all_event_triggers[2] = "Event Touch";
Game.all_event_triggers[3] = "Autorun";

Game.all_asset_flags[0] = "CollidePlayer";
Game.all_asset_flags[1] = "CollideNPC";
Game.all_asset_flags[2] = "Danger";
Game.all_asset_flags[3] = "Safe";
Game.all_asset_flags[4] = "Water";