#macro Game global.__game
#macro Identifiers global.__identifiers

Game = new (function() constructor {
    var file_default = new DataFile("data", false, true);
    var file_asset = new DataFile("assets", false, false);
    var file_terrain = new DataFile("terrain", true, false);
    
    self.meta = {
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
    };
    self.vars = {
        switches: array_create(BASE_GAME_VARIABLES),
        variables: [array_create(BASE_GAME_VARIABLES)],
        constants: [],
        triggers: array_create(FLAG_COUNT, ""),
        flags: array_create(FLAG_COUNT, ""),
    };
    self.data = [];
    self.graphics = {
        tilesets: [],
        overworlds: [],
        battlers: [],
        particles: [],
        ui: [],
        tile_animations: [],
        etc: [],
        skybox: [],
    };
    self.audio = {
        bgm: [],
        se: [],
    };
    self.meshes = [];
    self.mesh_autotiles = [];
    self.animations = [];
    self.events = {
        events: [],
        custom: [],
        prefabs: [],
    };
    self.maps = [];
    self.languages = {
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
    };
    
    // leave this here for now
    static Clear = function() {
        array_clear_instances(self.graphics.tilesets);
        array_clear_instances(self.graphics.overworlds);
        array_clear_instances(self.graphics.battlers);
        array_clear_instances(self.graphics.particles);
        array_clear_instances(self.graphics.ui);
        array_clear_instances(self.graphics.tile_animations);
        array_clear_instances(self.graphics.etc);
        array_clear_instances(self.graphics.skybox);
        array_resize(self.graphics.tilesets, 0);
        array_resize(self.graphics.overworlds, 0);
        array_resize(self.graphics.battlers, 0);
        array_resize(self.graphics.particles, 0);
        array_resize(self.graphics.ui, 0);
        array_resize(self.graphics.tile_animations, 0);
        array_resize(self.graphics.etc, 0);
        array_resize(self.graphics.skybox, 0);
        
        array_clear_instances(self.audio.bgm);
        array_clear_instances(self.audio.se);
        array_clear_instances(self.maps);
        array_clear_instances(self.meshes);
        array_clear_instances(self.mesh_autotiles);
        
        array_resize(self.audio.bgm, 0);
        array_resize(self.audio.se, 0);
        array_resize(self.animations, 0);
        array_resize(self.events.events, 0);
        array_resize(self.events.prefabs, 0);
        array_resize(self.events.custom, 0);
        array_resize(self.maps, 0);
        array_resize(self.mesh_autotiles, 0);
        
        Identifiers.Clear();
    };
    
    self.meta.export.locations[GameDataCategories.TILE_ANIMATIONS] = file_asset;
    self.meta.export.locations[GameDataCategories.TILESETS] = file_asset;
    self.meta.export.locations[GameDataCategories.BATTLERS] = file_asset;
    self.meta.export.locations[GameDataCategories.OVERWORLDS] = file_asset;
    self.meta.export.locations[GameDataCategories.PARTICLES] = file_asset;
    self.meta.export.locations[GameDataCategories.UI] = file_asset;
    self.meta.export.locations[GameDataCategories.SKYBOX] = file_asset;
    self.meta.export.locations[GameDataCategories.MISC] = file_asset;
    self.meta.export.locations[GameDataCategories.BGM] = file_asset;
    self.meta.export.locations[GameDataCategories.SE] = file_asset;
    self.meta.export.locations[GameDataCategories.MESH] = file_asset;
    self.meta.export.locations[GameDataCategories.MESH_AUTOTILES] = file_asset;
    self.meta.export.locations[GameDataCategories.MAP] = file_default;
    self.meta.export.locations[GameDataCategories.GLOBAL] = file_default;
    self.meta.export.locations[GameDataCategories.EVENTS]  = file_default;
    self.meta.export.locations[GameDataCategories.DATADATA] = file_default;
    self.meta.export.locations[GameDataCategories.ANIMATIONS] = file_default;
    self.meta.export.locations[GameDataCategories.TERRAIN] = file_terrain;
    self.meta.export.locations[GameDataCategories.LANGUAGE_TEXT] = file_default;
    
    for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
        self.vars.switches[i] = new DataValue("Switch" + string(i));
        self.vars.variables[i] = new DataValue("Variable" + string(i));
    }
    
    self.vars.triggers[0] = "Action Button";
    self.vars.triggers[1] = "Player Touch";
    self.vars.triggers[2] = "Event Touch";
    self.vars.triggers[3] = "Autorun";
    self.vars.flags[0] = "CollidePlayer";
    self.vars.flags[1] = "CollideNPC";
    self.vars.flags[2] = "Danger";
    self.vars.flags[3] = "Safe";
    self.vars.flags[4] = "Water";
})();

Identifiers = new (function() constructor {
    self.guids = { };
    self.internal = { };
    
    static Clear = function() {
        self.guids = { };
        self.internal = { };
    };
})();