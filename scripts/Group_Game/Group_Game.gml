#macro Game global.__game
#macro Identifiers global.__identifiers

enum GameExportFlags {
    COLLISION_SHAPES                = 0x0001,
}

Game = new GameDataStructure();

function GameDataStructure() constructor {
    self.meta = {
        project: {
            notes: "",
            summary: "Write a short summary in Global Game Settings",
            author: "Who made this?",
            id: string_hex(irandom(0xffffffff), 8),
        },
        export: {
            files: [new DataFile("data", false, true), new DataFile("assets", false, false), new DataFile("terrain", true, false)],
            locations: [],
            vertex_format: VertexFormatData.STANDARD,
            flags: 0,
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
            guid_current: 0
        },
    };
    self.vars = {
        switches: array_create(BASE_GAME_VARIABLES),
        variables: [array_create(BASE_GAME_VARIABLES)],
        constants: [],
        triggers: array_create(FLAG_COUNT, ""),
        flags: array_create(FLAG_COUNT, ""),
        effect_markers: array_create(FLAG_COUNT, ""),
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
    self.mesh_terrain = [];
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
    
    self.nosave = {
        map_terrain_gen: {
            choices: [],
            tex_size: 256,
            tex_r: -1,
            tex_g: -1,
            tex_b: -1,
            smoothness_r: 9,
            smoothness_g: 9,
            smoothness_b: 9,
            bands_r: 255,
            bands_g: 255,
            bands_b: 255,
        },
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
    
    enum GameDataCategories {
        DATA,
        ANIMATIONS,
        EVENTS,
        MAPS,
        TERRAIN,
        IMAGES,
        AUDIO,
        MESHES,
        LANGUAGE_TEXT,
        __COUNT
    }
    
    self.meta.export.locations[GameDataCategories.IMAGES] = 1;
    self.meta.export.locations[GameDataCategories.AUDIO] = 1;
    self.meta.export.locations[GameDataCategories.MESHES] = 1;
    self.meta.export.locations[GameDataCategories.MAPS] = 0;
    self.meta.export.locations[GameDataCategories.EVENTS]  = 0;
    self.meta.export.locations[GameDataCategories.DATA] = 0;
    self.meta.export.locations[GameDataCategories.ANIMATIONS] = 0;
    self.meta.export.locations[GameDataCategories.TERRAIN] = 2;
    self.meta.export.locations[GameDataCategories.LANGUAGE_TEXT] = 0;
    
    for (var i = 0; i < BASE_GAME_VARIABLES; i++) {
        self.vars.switches[i] = new DataValue("Switch " + string(i), false);
        self.vars.variables[i] = new DataValue("Variable " + string(i), 0);
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
    
    static InitializeDefaultObjects = function() {
        array_push(self.maps, new DataMap("Test Map", ""));
    };
};

Identifiers = {
    guids: { },
    internal: { },
    
    event_fixed_id: 0,
    
    Clear: function() {
        self.guids = { };
        self.internal = { };
        
        self.event_fixed_id = 0;
        
        Game.InitializeDefaultObjects();
    },
};

Game.InitializeDefaultObjects();