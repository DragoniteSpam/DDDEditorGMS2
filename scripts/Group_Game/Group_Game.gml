#macro Game global.__game
#macro Identifiers global.__identifiers

enum GameExportFlags {
    COLLISION_SHAPES                = 0x0001,
}

Game = new (function() constructor {
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
            guid_current: 0,
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
    
    self.default_event_nodes = array_create(EventNodeTypes._COUNT);
    
    static InitializeDefaultObjects = function() {
        array_push(self.maps, new DataMap("Test Map", ""));
        array_push(self.events.events, new DataEvent("Default Event"));
        
        #region event nodes
        self.default_event_nodes[EventNodeTypes.INPUT_TEXT] = new EventNodePeristent("InputText", [
            new EventNodeProperty("Help Text", DataTypes.STRING, 0, 1, false, "For example, \"Please enter your name\""),
            new EventNodeProperty("Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_input_type_data, function(event, index) {
                var raw = event.custom_data[1][0];
                if (!is_clamped(raw, 0, array_length(Game.vars.variables)))
                    return "n/a";
                return Game.vars.variables[raw].name;
            }),
            new EventNodeProperty("Kind", DataTypes.INT, 0, 1, false, 0, omu_event_attain_input_type_data, function(event, index) {
                switch (event.custom_data[2][0]) {
                    case 0: return "Text";
                    case 1: return "Text (Scribble safe)";
                    case 2: return "Integer";
                    case 3: return "Unsigned Integer";
                    case 4: return "Floating Point";
                }
                
                return "?";
            }),
            new EventNodeProperty("Char Limit", DataTypes.INT, 0, 1, false, 16, omu_event_attain_input_type_data)
        ]);
        self.default_event_nodes[EventNodeTypes.SHOW_SCROLLING_TEXT] = new EventNodePeristent("TextCrawl", [
            new EventNodeProperty("Text", DataTypes.STRING, 0, 250, false, "Text that is shown in the text crawl goes here"),
        ]);
        self.default_event_nodes[EventNodeTypes.SHOW_CHOICES] = new EventNodePeristent("ShowChoices", [
            // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
            new EventNodeProperty("Message", DataTypes.STRING, 0, 16, false, "Option 1"),
            new EventNodeProperty("ID", DataTypes.INT, 0, 16, false, 0),
        ], ["Option 1", "Option 2"]);
        self.default_event_nodes[EventNodeTypes.CONTROL_SWITCHES] = new EventNodePeristent("ControlGlobalSwitch", [
            new EventNodeProperty("Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_switch_data, function(event, index) {
                var raw = event.custom_data[0][0];
                if (!is_clamped(raw, 0, array_length(Game.vars.switches)))
                    return "n/a";
                return Game.vars.switches[raw].name;
            }),
            new EventNodeProperty("State", DataTypes.BOOL, 0, 1, false, false)
        ]);
        self.default_event_nodes[EventNodeTypes.CONTROL_VARIABLES] = new EventNodePeristent("ControlGlobalVariable", [
            new EventNodeProperty("Index", DataTypes.INT, 0, 1, false, -1, omu_event_attain_variable_data, function(event, index) {
                var raw = event.custom_data[0][0];
                if (!is_clamped(raw, 0, array_length(Game.vars.variables)))
                    return "n/a";
                return Game.vars.variables[raw].name;
            }),
            new EventNodeProperty("Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_variable_data),
            new EventNodeProperty("Relative?", DataTypes.BOOL, 0, 1, false, false)
        ]);
        self.default_event_nodes[EventNodeTypes.CONTROL_SELF_SWITCHES] = new EventNodePeristent("ControlSelfSwitch", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_switch_data, function(event, index) {
                return chr(ord("A") + event.custom_data[1][0]);
            }),
            new EventNodeProperty("State", DataTypes.BOOL, 0, 1, false, false)
        ]);
        self.default_event_nodes[EventNodeTypes.CONTROL_SELF_VARIABLES] = new EventNodePeristent("ControlSelfVariable", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Index", DataTypes.INT, 0, 1, false, 0, omu_event_attain_self_variable_data, function(event, index) {
                return chr(ord("A") + event.custom_data[1][0]);
            }),
            new EventNodeProperty("Value", DataTypes.FLOAT, 0, 1, false, 0, omu_event_attain_self_variable_data),
            new EventNodeProperty("Relative?", DataTypes.BOOL, 0, 1, false, false)
        ]);
        self.default_event_nodes[EventNodeTypes.CONTROL_TIME] = new EventNodePeristent("ControlTimer", [
            new EventNodeProperty("Counting Down?", DataTypes.BOOL, 0, 1, false, true),
            new EventNodeProperty("Initial Time (seconds)", DataTypes.INT),
            new EventNodeProperty("Display?", DataTypes.BOOL, 0, 1, false, false),
            new EventNodeProperty("Running?", DataTypes.BOOL, 0, 1, false, true),
        ]);
        self.default_event_nodes[EventNodeTypes.CONDITIONAL] = new EventNodePeristent("Conditional", [
            // conditional branch nodes are not actually handled as a prefab but i'm leaving this here for reference
            new EventNodeProperty("Type", DataTypes.INT),
            new EventNodeProperty("Index", DataTypes.INT),
            new EventNodeProperty("Comparison", DataTypes.INT),
            new EventNodeProperty("Value", DataTypes.INT),
            new EventNodeProperty("Code", DataTypes.INT),
        ], ["Success", "Fail"]);
        self.default_event_nodes[EventNodeTypes.INVOKE_EVENT] = new EventNodePeristent("WillNotBeImplemented", []);
        self.default_event_nodes[EventNodeTypes.COMMENT] = new EventNodePeristent("ImplementedElsewhere", [], []);
        self.default_event_nodes[EventNodeTypes.WAIT] = new EventNodePeristent("Wait", [
            new EventNodeProperty("Seconds", DataTypes.FLOAT, 0, 1, false, 1)
        ]);
        self.default_event_nodes[EventNodeTypes.TRANSFER_PLAYER] = new EventNodePeristent("TransferPlayer", [
            new EventNodeProperty("Map", DataTypes.MAP, 0, 1, false, 0, function() { show_message("wip"); }, function(event, index) {
                var map = guid_get(event.custom_data[0][0]);
                return map ? map.name : "<no map>";
            }),
            new EventNodeProperty("X", DataTypes.INT, 0, 1, false, 0, function() { show_message("wip"); }),
            new EventNodeProperty("Y", DataTypes.INT, 0, 1, false, 0, function() { show_message("wip"); }),
            new EventNodeProperty("A", DataTypes.INT, 0, 1, false, 0, function() { show_message("wip"); }),
            new EventNodeProperty("Direction", DataTypes.INT, 0, 1, false, 0, function() { show_message("wip"); }, function(event, index) {
                return global.rpg_maker_directions[event.custom_data[4][0]];
            }),
            new EventNodeProperty("FadeColor", DataTypes.COLOR, 0, 1, false, c_black, function() { show_message("wip"); }),
            new EventNodeProperty("FadeTime", DataTypes.FLOAT, 0, 1, false, 1, function() { show_message("wip"); }),
        ]);
        /* */ self.default_event_nodes[EventNodeTypes.SET_ENTITY_LOCATION] = new EventNodePeristent("NotYetImplemented", []);
        /* */ self.default_event_nodes[EventNodeTypes.SCROLL_MAP] = new EventNodePeristent("NotYetImplemented", []);
        /* */ self.default_event_nodes[EventNodeTypes.SET_MOVEMENT_ROUTE] = new EventNodePeristent("NotYetImplemented", []);
        self.default_event_nodes[EventNodeTypes.TINT_SCREEN] = new EventNodePeristent("TintScreen", [
            new EventNodeProperty("Color", DataTypes.COLOR, 0, 1, false, c_white),
            new EventNodeProperty("Alpha", DataTypes.FLOAT, 0, 1, false, 1),
            new EventNodeProperty("Time", DataTypes.FLOAT, 0, 1, false, 1),
            new EventNodeProperty("Wait?", DataTypes.BOOL, 0, 1, false, true),
        ]);
        self.default_event_nodes[EventNodeTypes.FLASH_SCREEN] = new EventNodePeristent("WillNotBeImplemented", []);
        self.default_event_nodes[EventNodeTypes.SHAKE_SCREEN] = new EventNodePeristent("ShakeScreen", [
            new EventNodeProperty("PowerX", DataTypes.FLOAT, 0, 1, false, 0.25),
            new EventNodeProperty("PowerY", DataTypes.FLOAT, 0, 1, false, 0.25),
            new EventNodeProperty("Speed", DataTypes.FLOAT, 0, 1, false, 0.25),
            new EventNodeProperty("Duration", DataTypes.FLOAT, 0, 1, false, 1),
            new EventNodeProperty("Wait?", DataTypes.BOOL, 0, 1, false, true),
        ]);
        self.default_event_nodes[EventNodeTypes.PLAY_BGM] = new EventNodePeristent("PlayBGM", [
            new EventNodeProperty("BGM", DataTypes.AUDIO_BGM, 0),
            new EventNodeProperty("Volume", DataTypes.INT, 0, 1, false, 100),
            new EventNodeProperty("Pitch", DataTypes.INT, 0, 1, false, 100)
        ]);
        self.default_event_nodes[EventNodeTypes.FADE_BGM] = new EventNodePeristent("FadeBGM", [
            new EventNodeProperty("Volume", DataTypes.INT),
            new EventNodeProperty("Time", DataTypes.FLOAT, 0, 1, false, 1),
            new EventNodeProperty("Stop On Complete?", DataTypes.BOOL, 0, 1, false, true)
        ]);
        self.default_event_nodes[EventNodeTypes.RESUME_BGM] = new EventNodePeristent("ResumeAutomaticBGM", []);
        // if you want fancier audio controls for sound effects, make an advanced event - i'm not going to write the FMOD effects into the basic one
        self.default_event_nodes[EventNodeTypes.PLAY_SE] = new EventNodePeristent("PlaySoundEffect", [
            new EventNodeProperty("Sound Effect", DataTypes.AUDIO_SE, 0),
            new EventNodeProperty("Volume", DataTypes.INT, 0, 1, false, 100),
            new EventNodeProperty("Pitch", DataTypes.INT, 0, 1, false, 100)
        ]);
        self.default_event_nodes[EventNodeTypes.STOP_SE] = new EventNodePeristent("StopAllSoundEffects", []);
        /* */ self.default_event_nodes[EventNodeTypes.RETURN_TO_TITLE] = new EventNodePeristent("NotYetImplemented", []);
        self.default_event_nodes[EventNodeTypes.CHANGE_MAP_DISPLAY_NAME] = new EventNodePeristent("ChangeMapDisplayName", [
            new EventNodeProperty("Map", DataTypes.MAP),
            new EventNodeProperty("New Name", DataTypes.STRING, 0, 1, false, "Whatever the new name is"),
        ]);
        /* */ self.default_event_nodes[EventNodeTypes.CHANGE_MAP_TILESET] = new EventNodePeristent("NotYetImplemented", []);
        /* */ self.default_event_nodes[EventNodeTypes.CHANGE_MAP_BATTLE_SCENE] = new EventNodePeristent("NotYetImplemented", []);
        /* */ self.default_event_nodes[EventNodeTypes.CHANGE_MAP_SKYBOX] = new EventNodePeristent("NotYetImplemented", []);
        self.default_event_nodes[EventNodeTypes.SCRIPT] = new EventNodePeristent("Script", [
            new EventNodeProperty("Code", DataTypes.CODE, 0, 1, true, "")
        ]);
        /* */ self.default_event_nodes[EventNodeTypes.AUDIO_CONTORLS] = new EventNodePeristent("NotYetImplemented", []);
        self.default_event_nodes[EventNodeTypes.DEACTIVATE_EVENT] = new EventNodePeristent("Deactivate This Event Page", []);
        self.default_event_nodes[EventNodeTypes.SET_ENTITY_MESH] = new EventNodePeristent("SetEntityMesh", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Mesh", DataTypes.MESH),
        ]);
        self.default_event_nodes[EventNodeTypes.SET_ENTITY_SPRITE] = new EventNodePeristent("SetEntitySprite", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Sprite", DataTypes.IMG_OVERWORLD),
        ]);
        self.default_event_nodes[EventNodeTypes.SET_MESH_ANIMATION] = new EventNodePeristent("SetEntityMeshAnimation", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Speed", DataTypes.FLOAT, 0, 1, false, 30),
            new EventNodeProperty("EndAction", DataTypes.INT, 0, 1, false, 0, omu_event_attain_mesh_anim_end_action, function(event, index) {
                return global.animation_end_action_names[event.custom_data[2][0]];
            }),
        ]);
        self.default_event_nodes[EventNodeTypes.SCHEDULE_EVENT] = new EventNodePeristent("ScheduleEvent", [
            new EventNodeProperty("Entity", DataTypes.ENTITY),
            new EventNodeProperty("Time", DataTypes.FLOAT),
        ], ["Outbound", "Scheduled Event"]);
        
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
            RETURN_TO_TITLE, CHANGE_MAP_DISPLAY_NAME, CHANGE_MAP_TILESET, CHANGE_MAP_BATTLE_SCENE, CHANGE_MAP_SKYBOX,
            SCRIPT, AUDIO_CONTORLS, DEACTIVATE_EVENT, SET_MESH_ANIMATION, SCHEDULE_EVENT, ADVANCED3, ADVANCED4, ADVANCED5, ADVANCED6, ADVANCED7,
            // i forgot to put this one with the other text nodes
            SHOW_CHOICES, SET_ENTITY_SPRITE, SET_ENTITY_MESH,
            _COUNT
        }
        #endregion
    };
})();

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