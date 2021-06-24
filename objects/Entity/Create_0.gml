name = "Entity";
etype = ETypes.ENTITY;
etype_flags = 0;
exist_in_map = true;
is_component = false;

refid_set(id, refid_generate());

tmx_id = 0;

Stuff.map.active_map.contents.population[ETypes.ENTITY]++;

// for fusing all static objects such as ground tiles and houses together,
// so the computer doesn't waste time drawing every single visible Entity
// individually
batch = null;

// when creating one giant collision shape
batch_collision = null;

// for things that don't fit into the above category, including but not limited
// to NPCs, things that animate, things that move and things that need special shaders
render = null;

// files
save_script = serialize_save_entity;

// you can have scripts that do both, if you want to have a static thing that
// sparkles or something

// serialize
xx = 0;           // u32
yy = 0;           // u32
zz = 0;           // u32

off_xx = 0;       // f32
off_yy = 0;       // f32
off_zz = 0;       // f32

rot_xx = 0;       // u16
rot_yy = 0;       // u16
rot_zz = 0;       // u16

scale_xx = 1;     // f32
scale_yy = 1;     // f32
scale_zz = 1;     // f32

object_events = [];         // i'm imposing a hard limit of 10 of these

switches = array_create(BASE_SELF_VARIABLES, 0);
variables = array_create(BASE_SELF_VARIABLES, 0);

// options
direction_fix = true;
always_update = false;
preserve_on_save = false;
reflect = false;
slope = ATMask.NONE;

generic_data = [];

// autonomous movement - only useful for things not marked as "static"
autonomous_movement = AutonomousMovementTypes.FIXED;
autonomous_movement_speed = 3;                            // 0: 0.125, 1: 0.25, 2: 0.5, 3: 1, 4: 2, 5: 4
autonomous_movement_frequency = 2;                        // 0 through 4
autonomous_movement_route = NULL;
movement_routes = [];                                                           // array of MoveRoute structs

enum AutonomousMovementTypes {
    FIXED,
    RANDOM,
    APPROACH,
    CUSTOM
}

// these are a formality
target_xx = xx;
target_yy = yy;
target_zz = zz;
previous_xx = xx;
previous_yy = yy;
previous_zz = zz;

/* s */ is_static = false;

// editor properties

// the game will know in advance whether something is to be batched or not.
// the editor may chance this on the fly. remember to override this in dynamic entities.
batchable = true;
batch_addr = undefined;                // pointer to a batch struct
modification = Modifications.CREATE;

translateable = true;
offsettable = false;
rotateable = false;
scalable = false;

slot = MapCellContents.TILE;
listed = false; // sigh

enum Modifications {
    NONE,
    CREATE,
    UPDATE,
    REMOVE
}

// whether you're allowed to stick multiple of these (same type of)
// objects at in the same cell
coexist = false;

// collision data
cobject = noone;

on_select = safc_on_entity;
on_deselect = safc_on_entity_deselect;
on_select_ui = safc_on_entity_ui;
get_bounding_box = entity_bounds_one;

SetCollisionTransform = function() {
    if (c_object_exists(cobject)) {
        c_world_add_object(cobject);
        c_object_set_userid(cobject, self.id);
        c_transform_position(xx * TILE_WIDTH, yy * TILE_HEIGHT, zz * TILE_DEPTH);
        c_object_apply_transform(cobject);
        c_transform_identity();
    }
};

SetStatic = function(state) {
    return false;
};

SaveAsset = function(directory) {
    directory = self.GetSaveAssetName(directory);
    buffer_write_file(json_stringify(self.CreateJSON()), directory);
};

LoadJSONBase = function(source) {
    self.name = source.name;
    refid_set(self, source.refid);
    self.xx = source.position.x;
    self.yy = source.position.y;
    self.zz = source.position.z;
    self.off_xx = source.offset.x;
    self.off_yy = source.offset.y;
    self.off_zz = source.offset.z;
    self.rot_xx = source.rotation.x;
    self.rot_yy = source.rotation.y;
    self.rot_zz = source.rotation.z;
    self.scale_xx = source.scale.x;
    self.scale_yy = source.scale.y;
    self.scale_zz = source.scale.z;
    self.switches = source.switches;
    self.variables = source.variables;
    self.generic_data = source.generic_data;
    self.object_events = source.events;
    self.direction_fix = source.options.direction_fix;
    self.always_update = source.options.always_update;
    self.preserve_on_save = source.options.preserve;
    self.reflect = source.options.reflect;
    self.slope = source.options.slope;
    self.is_static = source.options.is_static;
    self.autonomous_movement = source.autonomous.type;
    self.autonomous_movement_speed = source.autonomous.speed;
    self.autonomous_movement_frequency = source.autonomous.frequency;
    self.autonomous_movement_route = source.autonomous.route;
    self.movement_routes = source.autonomous.routes;
    self.tmx_id = source.tmx_id;
};

LoadJSON = function(source) {
    self.LoadJSONBase(source);
};

CreateJSONBase = function() {
    return {
        name: self.name,
        type: self.etype,
        refid: self.REFID,
        position: {
            x: self.xx,
            y: self.yy,
            z: self.zz,
        },
        offset: {
            x: self.off_xx,
            y: self.off_yy,
            z: self.off_zz,
        },
        rotation: {
            x: self.rot_xx,
            y: self.rot_yy,
            z: self.rot_zz,
        },
        scale: {
            x: self.scale_xx,
            y: self.scale_yy,
            z: self.scale_zz,
        },
        switches: self.switches,
        variables: self.variables,
        generic_data: self.generic_data,
        events: self.object_events,
        options: {
            direction_fix: self.direction_fix,
            always_update: self.always_update,
            preserve: self.preserve_on_save,
            reflect: self.reflect,
            slope: self.slope,
            is_static: self.is_static,
        },
        autonomous: {
            type: self.autonomous_movement,
            speed: self.autonomous_movement_speed,
            frequency: self.autonomous_movement_frequency,
            route: self.autonomous_movement_route,
            routes: self.movement_routes,
        },
        tmx_id: self.tmx_id,
    };
};

CreateJSON = function() {
    return self.CreateJSONBase();
};

GetSaveAssetName = function(directory) {
    return directory + string_replace_all(self.REFID, ":", "_") + ".ass";
};