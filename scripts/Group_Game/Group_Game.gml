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
};

for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    Game.switches[i] = new DataValue("Switch" + string(i));
    Game.variables[i] = new DataValue("Variable" + string(i));
}