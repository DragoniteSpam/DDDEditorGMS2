#macro Game global.__game

Game = {
    project: {
        notes: "",
        summary: "Write a short summary in Global Game Settings",
        author: "Who made this?",
        id: string_hex(irandom(0xffffffff), 8),
    },
};