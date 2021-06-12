#macro Game global.__game
#macro Identifiers global.__identifiers

var file_default = new DataFile("data", false, true);
var file_asset = new DataFile("assets", false, false);
var file_terrain = new DataFile("terrain", true, false);

Game = {
    meta: {
        project: {
            notes: "",
            summary: "Write a short summary in Global Game Settings",
            author: "Who made this?",
            id: string_hex(irandom(0xffffffff), 8),
        },
        export: {
            files: [file_default, file_asset, file_terrain],
            locations: [],
        },
        
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
        extra: {
            guid_current: 0,
        },
    },
    vars: {
        switches: array_create(BASE_GAME_VARIABLES),
        variables: [array_create(BASE_GAME_VARIABLES)],
        constants: [],
        event_triggers: array_create(FLAG_COUNT, ""),
        asset_flags: array_create(FLAG_COUNT, ""),
    },
    data: [],
    graphics: {
        tilesets: ds_list_create(),
        overworlds: ds_list_create(),
        battlers: ds_list_create(),
        particles: ds_list_create(),
        ui: ds_list_create(),
        tile_animations: ds_list_create(),
        etc: ds_list_create(),
        skybox: ds_list_create(),
    },
    audio: {
        bgm: ds_list_create(),
        se: ds_list_create(),
    },
    meshes: [],
    mesh_autotiles: ds_list_create(),
    animations: [],
    events: {
        events: ds_list_create(),
        custom: ds_list_create(),
        prefabs: ds_list_create(),
    },
    maps: ds_list_create(),
    languages: {
        /*
         * example:
         * {
         *      "English": {
         *          "string1": "string1",
         *          "string2": "string2"
         *      },
         *      "Portuguese": {
         *          "string1": "texto1",
         *          "string2": "texto2"
         *      }
         * }
         */
        names: ["English"],
        text: { English: { } },
    },
    
    // leave this here for now
    Clear: function() {
        ds_list_clear_instances(self.graphics.tilesets);
        ds_list_clear_instances(self.graphics.overworlds);
        ds_list_clear_instances(self.graphics.battlers);
        ds_list_clear_instances(self.graphics.particles);
        ds_list_clear_instances(self.graphics.ui);
        ds_list_clear_instances(self.graphics.tile_animations);
        ds_list_clear_instances(self.graphics.etc);
        ds_list_clear_instances(self.graphics.skybox);
        ds_list_clear_instances(self.mesh_autotiles);
        ds_list_clear_instances(self.maps);
        ds_list_clear_instances(self.events.events);
        ds_list_clear_instances(self.events.prefabs);
        ds_list_clear_instances(self.events.custom);
        
        array_clear_instances(self.animations);
        array_clear_instances(self.meshes);
        
        Identifiers.Clear();
    },
};

Identifiers = {
    guids: { },
    internal: { },
    
    Clear: function() {
        self.guids = { };
        self.internal = { };
    },
};

Game.meta.export.locations[GameDataCategories.TILE_ANIMATIONS] = file_asset;
Game.meta.export.locations[GameDataCategories.TILESETS] = file_asset;
Game.meta.export.locations[GameDataCategories.BATTLERS] = file_asset;
Game.meta.export.locations[GameDataCategories.OVERWORLDS] = file_asset;
Game.meta.export.locations[GameDataCategories.PARTICLES] = file_asset;
Game.meta.export.locations[GameDataCategories.UI] = file_asset;
Game.meta.export.locations[GameDataCategories.SKYBOX] = file_asset;
Game.meta.export.locations[GameDataCategories.MISC] = file_asset;
Game.meta.export.locations[GameDataCategories.BGM] = file_asset;
Game.meta.export.locations[GameDataCategories.SE] = file_asset;
Game.meta.export.locations[GameDataCategories.MESH] = file_asset;
Game.meta.export.locations[GameDataCategories.MESH_AUTOTILES] = file_asset;
Game.meta.export.locations[GameDataCategories.MAP] = file_default;
Game.meta.export.locations[GameDataCategories.GLOBAL] = file_default;
Game.meta.export.locations[GameDataCategories.EVENTS]  = file_default;
Game.meta.export.locations[GameDataCategories.DATADATA] = file_default;
Game.meta.export.locations[GameDataCategories.DATA_INST] = file_default;
Game.meta.export.locations[GameDataCategories.ANIMATIONS] = file_default;
Game.meta.export.locations[GameDataCategories.TERRAIN] = file_terrain;
Game.meta.export.locations[GameDataCategories.LANGUAGE_TEXT] = file_default;

for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
    Game.vars.switches[i] = new DataValue("Switch" + string(i));
    Game.vars.variables[i] = new DataValue("Variable" + string(i));
}

Game.vars.triggers[0] = "Action Button";
Game.vars.triggers[1] = "Player Touch";
Game.vars.triggers[2] = "Event Touch";
Game.vars.triggers[3] = "Autorun";

Game.vars.flags[0] = "CollidePlayer";
Game.vars.flags[1] = "CollideNPC";
Game.vars.flags[2] = "Danger";
Game.vars.flags[3] = "Safe";
Game.vars.flags[4] = "Water";