#macro Game global.__game

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
    all_game_constants: [],
    
    title_screen: NULL,
    start: {
        x: 0,
        y: 0,
        z: 0,
        direction: 0,
        map: NULL,
    },
    
    grid: {
        snap: true,
        chunk_size: 32,
    },
};

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